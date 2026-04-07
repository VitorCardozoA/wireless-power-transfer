clear;
clc;
close all;

%% Parametros do projeto
Vs = 400;
Rc = 320;
k = 0.4;
f = 50e3;
w0 = 2*pi*f;

%% Varreduras
passo = 10e-6;
Lp_range = 1e-6:passo:3e-3;
Ls_range = 1e-6:passo:3e-3;

%% Corrente/potencia alvo
Iout = Vs / Rc;
Pout = Rc * abs(Iout)^2;

%% Ponto de referencia usado no artigo
Lp_selected = 2211e-6;
Ls_selected = 2211e-6;

%% Grades 2D
[LP, LS] = meshgrid(Lp_range, Ls_range);

%% Resistencias equivalentes
Rp_range = Lp_range * 1000;
Rs_range = Ls_range * 1000;
[RP, RS] = meshgrid(Rp_range, Rs_range);

%% Capacitores serie
Cp_range = 1 ./ (Lp_range * w0^2);
Cs_range = 1 ./ (Ls_range * w0^2);
[CP, CS] = meshgrid(Cp_range, Cs_range);

%% Acoplamento
M = k .* sqrt(LP .* LS);

%% Impedancia equivalente no primario
den = (RS + Rc).^2 + (LS .* w0 - 1 ./ (CS .* w0)).^2;
ReZ = RP + ((M.^2) .* (w0.^2) .* (RS + Rc)) ./ den;
ImZ = (w0 .* LP - 1 ./ (w0 .* CP)) ...
    - (LS .* w0 - 1 ./ (CS .* w0)) .* ((M.^2) .* (w0.^2)) ./ den;
Z = ReZ + 1j * ImZ;

%% Corrente/tensao no primario
Zs_total = RS + 1j * w0 .* LS + 1 ./ (1j * w0 .* CS) + Rc;
Iin = (Iout .* Zs_total) ./ (1j .* M .* w0);
Vp = Z .* Iin;

%% Potencias e eficiencia
Sin = Vp .* conj(Iin);
Pin = real(Sin);
Pin(Pin <= 0 | ~isfinite(Pin)) = NaN;
N = Pout ./ Pin;
N(N <= 0 | N > 1) = NaN;

%% Selecao pela janela de |Vp|
Vmod = abs(Vp);
Vmin = 350;
Vmax = 400;
mask = (Vmod >= Vmin) & (Vmod <= Vmax);

[idxLs_valid, idxLp_valid] = find(mask);
validLp = Lp_range(idxLp_valid);
validLs = Ls_range(idxLs_valid);
validVp = Vmod(mask);

[~, idxLp_selected] = min(abs(Lp_range - Lp_selected));
[~, idxLs_selected] = min(abs(Ls_range - Ls_selected));

%% Graficos
figSelection = figure(1);
clf(figSelection);
figSelection.Color = 'white';
figSelection.Position = [80 80 1450 920];

tl = tiledlayout(figSelection, 2, 2, 'Padding', 'compact', ...
    'TileSpacing', 'compact');

nexttile;
surf(LP * 1e6, LS * 1e6, Vmod, 'EdgeColor', 'none', ...
    'FaceColor', 'interp');
view(38, 28);
shading interp;
colormap(gca, turbo);
cb = colorbar;
cb.Label.String = 'Vp (V)';
cb.Color = [0.1 0.1 0.1];
cb.FontWeight = 'bold';
clim([min(Vmod(:)), max(Vmod(:))]);
title('(a)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Lp (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Ls (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
zlabel('Vp (V)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
applyLightAxesStyle(gca);

nexttile;
scatter3(validLp * 1e6, validLs * 1e6, validVp, 18, validVp, 'filled', ...
    'MarkerEdgeColor', [0.08 0.08 0.08], 'LineWidth', 0.25);
view(42, 18);
colormap(gca, turbo);
cb = colorbar;
cb.Label.String = 'Vp (V)';
cb.Color = [0.1 0.1 0.1];
cb.FontWeight = 'bold';
title('(b)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Lp (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Ls (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
zlabel('Vp (V)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
applyLightAxesStyle(gca);

nexttile;
surf(LP * 1e6, LS * 1e6, N * 100, 'EdgeColor', 'none', ...
    'FaceColor', 'interp');
view(38, 28);
shading interp;
colormap(gca, parula);
cb = colorbar;
cb.Label.String = 'Rendimento (%)';
cb.Color = [0.1 0.1 0.1];
cb.FontWeight = 'bold';
clim([0 100]);
title('(c)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Lp (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Ls (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
zlabel('Rendimento (%)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
applyLightAxesStyle(gca);

nexttile;
plot(Ls_range * 1e6, N(:, idxLp_selected) * 100, ...
    'Color', [0.05 0.32 0.68], 'LineWidth', 2.6);
hold on;
xline(Ls_range(idxLs_selected) * 1e6, '--', 'Color', [0.85 0.2 0.1], ...
    'LineWidth', 1.5);
hold off;
ylim([0 100]);
title('(d)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('Ls (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Rendimento (%)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
applyLightAxesStyle(gca);

title(tl, 'Mapas de selecao do projeto SS', 'FontSize', 15, ...
    'FontWeight', 'bold', 'Color', [0.1 0.1 0.1]);

figZoom = figure(2);
clf(figZoom);
figZoom.Color = 'white';
figZoom.Position = [120 120 980 760];
scatter(validLp * 1e6, validLs * 1e6, 28, validVp, 'filled', ...
    'MarkerFaceAlpha', 0.78, 'MarkerEdgeColor', [0.1 0.1 0.1], ...
    'LineWidth', 0.25);
hold on;
plot(Lp_range(idxLp_selected) * 1e6, Ls_range(idxLs_selected) * 1e6, ...
    'p', 'MarkerSize', 14, 'MarkerFaceColor', [0.95 0.45 0.12], ...
    'MarkerEdgeColor', [0.15 0.15 0.15], 'LineWidth', 1.2);
hold off;
colormap(gca, turbo);
cb = colorbar;
cb.Label.String = 'Vp (V)';
cb.Color = [0.1 0.1 0.1];
cb.FontWeight = 'bold';

xPad = max(30, 0.15 * (max(validLp) - min(validLp)) * 1e6);
yPad = max(30, 0.15 * (max(validLs) - min(validLs)) * 1e6);
xlim([min(validLp) * 1e6 - xPad, max(validLp) * 1e6 + xPad]);
ylim([min(validLs) * 1e6 - yPad, max(validLs) * 1e6 + yPad]);

ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.ColorOrder = [0.05 0.32 0.68; 0.95 0.45 0.12];
xlabel('Lp (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
ylabel('Ls (\muH)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
title('Regiao valida e ponto selecionado', 'FontSize', 14, ...
    'FontWeight', 'bold', 'Color', 'k');
legend('Solucoes validas', 'Ponto selecionado', 'Location', 'best');
applyLightAxesStyle(gca);
box on;

function applyLightAxesStyle(ax)
ax.Color = 'white';
ax.XColor = [0.1 0.1 0.1];
ax.YColor = [0.1 0.1 0.1];
ax.ZColor = [0.1 0.1 0.1];
ax.GridColor = [0.72 0.76 0.82];
ax.GridAlpha = 0.35;
ax.MinorGridColor = [0.84 0.87 0.9];
ax.MinorGridAlpha = 0.2;
ax.LineWidth = 1;
ax.Box = 'on';
ax.Layer = 'top';
grid(ax, 'on');
end
