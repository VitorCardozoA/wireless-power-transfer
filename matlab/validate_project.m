function validate_project
clc;
close all;

projectRoot = fileparts(fileparts(mfilename('fullpath')));
matlabDir = fullfile(projectRoot, 'matlab');
simulinkDir = fullfile(projectRoot, 'simulink');
figureDir = fullfile(projectRoot, 'assets', 'figures');
docsDir = fullfile(projectRoot, 'docs');

addpath(matlabDir, simulinkDir);

if ~exist(figureDir, 'dir')
    mkdir(figureDir);
end

if ~exist(docsDir, 'dir')
    mkdir(docsDir);
end

fprintf('==> Verificando scripts MATLAB com Code Analyzer...\n');
assertClean(checkcode(fullfile(matlabDir, 'parametric_sweep.m')), 'parametric_sweep.m');
assertClean(checkcode(fullfile(matlabDir, 'simulink_parameters.m')), 'simulink_parameters.m');

fprintf('==> Gerando figuras do estudo parametrico...\n');
set(groot, 'defaultFigureVisible', 'off');
figureCleanup = onCleanup(@() set(groot, 'defaultFigureVisible', 'on'));

runProjectScript(fullfile(matlabDir, 'parametric_sweep.m'));
exportFigure(1, fullfile(figureDir, 'selection-maps.png'));
exportFigure(2, fullfile(figureDir, 'valid-region-zoom.png'));
close all;

fprintf('==> Atualizando e simulando o modelo Simulink...\n');
warning('off', 'Simulink:blocks:DivideByZero');
warningCleanup = onCleanup(@() warning('on', 'Simulink:blocks:DivideByZero'));

simWorkspace = fullfile(tempdir, 'wireless-power-transfer-validation');
if ~exist(simWorkspace, 'dir')
    mkdir(simWorkspace);
end

simDirCleanup = onCleanup(@() cd(projectRoot));
cd(simWorkspace);

loadSimulinkParameters(fullfile(matlabDir, 'simulink_parameters.m'));
load_system('ss_topology');
set_param('ss_topology', 'SimulationCommand', 'update');
sim('ss_topology');
close_system('ss_topology', 0);

fprintf('==> Recalculando a variacao de frequencia do artigo...\n');
frequencySweep = calculateFrequencySweep();
writetable(frequencySweep, fullfile(docsDir, 'frequency-sweep-validation.csv'));
disp(frequencySweep);

cleanupGeneratedArtifacts(projectRoot);

fprintf('==> Validacao concluida com sucesso.\n');
end

function runProjectScript(scriptPath)
currentDir = pwd;
dirCleanup = onCleanup(@() cd(currentDir));
run(scriptPath);
end

function loadSimulinkParameters(scriptPath)
currentDir = pwd;
dirCleanup = onCleanup(@() cd(currentDir));
normalizedPath = strrep(scriptPath, '\', '/');
evalin('base', sprintf("run('%s');", normalizedPath));
end

function cleanupGeneratedArtifacts(projectRoot)
generatedPaths = {
    fullfile(projectRoot, 'ss_topology.slxc')
    fullfile(projectRoot, 'slprj')
    fullfile(projectRoot, 'matlab', 'ss_topology.slxc')
    fullfile(projectRoot, 'matlab', 'slprj')
    fullfile(projectRoot, 'simulink', 'ss_topology.slxc')
    fullfile(projectRoot, 'simulink', 'slprj')
    };

for idx = 1:numel(generatedPaths)
    generatedPath = generatedPaths{idx};
    if exist(generatedPath, 'dir')
        rmdir(generatedPath, 's');
    elseif exist(generatedPath, 'file')
        delete(generatedPath);
    end
end
end

function assertClean(issues, fileLabel)
if isempty(issues)
    return;
end

messageLines = compose("- Linha %d: %s", [issues.line]', string({issues.message}'));
error("O arquivo %s ainda possui avisos do Code Analyzer:\n%s", ...
    fileLabel, strjoin(messageLines, newline));
end

function exportFigure(figureNumber, outputPath)
fig = findall(groot, 'Type', 'figure', 'Number', figureNumber);
if isempty(fig)
    error('Figura %d nao foi encontrada para exportacao.', figureNumber);
end

fig.Color = 'white';
exportgraphics(fig, outputPath, 'Resolution', 220, ...
    'BackgroundColor', 'white');
end

function frequencySweep = calculateFrequencySweep()
Vp_rms = 350.5;
Lp = 2211e-6;
Rp = 2.211;
Ls = 2211e-6;
Rs = 2.211;
k = 0.4;
Rc = 320;

f0 = 50e3;
w0 = 2 * pi * f0;
Cp = 1 / (Lp * w0^2);
Cs = 1 / (Ls * w0^2);
M = k * sqrt(Lp * Ls);

freqs = [45e3; 50e3; 55e3];
pin = zeros(size(freqs));
pout = zeros(size(freqs));
qin = zeros(size(freqs));
sabs = zeros(size(freqs));
fp = zeros(size(freqs));
eff = zeros(size(freqs));

for idx = 1:numel(freqs)
    w = 2 * pi * freqs(idx);
    Zp = Rp + 1j * w * Lp + 1 / (1j * w * Cp);
    Zs = Rs + Rc + 1j * w * Ls + 1 / (1j * w * Cs);
    Zin = Zp + (w^2 * M^2) / Zs;

    Iin = Vp_rms / Zin;
    Iout = (1j * w * M / Zs) * Iin;
    Sin = Vp_rms * conj(Iin);

    pin(idx) = real(Sin);
    pout(idx) = Rc * abs(Iout)^2;
    qin(idx) = imag(Sin);
    sabs(idx) = abs(Sin);
    fp(idx) = pin(idx) / sabs(idx);
    eff(idx) = 100 * pout(idx) / pin(idx);
end

frequencySweep = table( ...
    freqs / 1e3, pin, pout, qin, sabs, fp, eff, ...
    'VariableNames', {'f_kHz', 'Pin_W', 'Pout_W', 'Qin_var', 'S_VA', 'FP', 'Eff_pct'});
end
