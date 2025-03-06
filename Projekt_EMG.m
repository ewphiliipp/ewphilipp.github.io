% Elektrophysiologische Daten - Vorverarbeitung

%% Refreshen
clc, clear, close all
pkg load signal

load('Squat1.mat');

%ROHDATEN

figure('name', 'Rohdaten')

% Linke Seite
subplot(4,2,1)
plot(data(:,1))
title('M. Gastrocnemius medialis (links)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,3)
plot(data(:,2))
title('M. Tibialis anterior (links)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,5)
plot(data(:,3))
title('M. Biceps femoris (links)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,7)
plot(data(:,4))
title('M. Rectus femoris (links)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

% Rechte Seite
subplot(4,2,2)
plot(data(:,5))
title('M. Gastrocnemius medialis (rechts)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,4)
plot(data(:,6))
title('M. Tibialis anterior (rechts)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,6)
plot(data(:,7))
title('M. Biceps femoris (rechts)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')

subplot(4,2,8)
plot(data(:,8))
title('M. Rectus femoris (rechts)')
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')


% Vollgleichrichtung
data_abs = abs(data);

% Plot zum grafischen Überprüfen
figure('name', 'Vollgleichgerichtet')

subplot_titles_left = {'M. Gastrocnemius medialis (links)', 'M. tibialis anterior (links)', ...
    'M. Biceps femoris (links)', 'M. Rectus femoris (links)'};

subplot_titles_right = {'M. Gastrocnemius medialis (rechts)', 'M. tibialis anterior (rechts)', ...
    'M. Biceps femoris (rechts)', 'M. Rectus femoris (rechts)'};

for muscle = 1 : 4
    subplot(4,2,2*(muscle-1)+1) % Linker Subplot
    plot(data_abs(:,muscle))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_left{muscle})

    subplot(4,2,2*muscle) % Rechter Subplot
    plot(data_abs(:,muscle+4))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_right{muscle})
end

% Digitales Filtern


% Da Menschen keine Bewegungen erzeugen können, die sich oberhalb von 10 Hz abspielen, liegt es hier nahe,
% einen Butterworth Filter 2ter Ordnung mit lowpass Eigenschaften & einer Cutoff Frequency von 10 Hz zu erstellen


cutoff = 10;
freq = 1000;
order = 2;
[b,a] = butter(order, cutoff/(freq/2), 'low');  % cutoff/(freq/2) = weil die Filterfrequenz in radians angegeben werden muss
data_filt = filter(b,a, data_abs);
% Plot zum grafischen Überprüfen
figure('name', 'Gefiltert')

for muscle = 1 : 4
    subplot(4,2,2*(muscle-1)+1) % Linker Subplot
    plot(data_filt(:,muscle))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_left{muscle})

    subplot(4,2,2*muscle) % Rechter Subplot
    plot(data_filt(:,muscle+4))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_right{muscle})
end

% Probiert unterschiedliche Cutoff Frequenzen aus und stellt die so gefilterten
% Daten wieder grafisch dar.


% 2c): Glätten
% mittelwert von den gefilterten daten alle 100 frames = Datasmooth
window_length = 100;
data_smooth = movfun(@mean, data_filt, window_length);

% Plot zum grafischen Überprüfen
figure('name', 'Geglättet')

for muscle = 1 : 4
    subplot(4,2,2*(muscle-1)+1) % Linker Subplot
    plot(data_smooth(:,muscle))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_left{muscle})

    subplot(4,2,2*muscle) % Rechter Subplot
    plot(data_smooth(:,muscle+4))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_right{muscle})
end

% Maximale aktivierung des Muskels um Zeitpunkt in der Bewegung zu analysieren
% Peak von Rectus Femoris um auf tiefsten punkt der Kniebeuge schließen könnte.
% maximale Aktivierung der Kniestrecker durch Dehnungs Verkürzungszyklus?
%Zudem sind die Maxima auf beiden Seiten zu ca. demselben Zeitpunkt

[pks, locs] = findpeaks(data_smooth(:,4), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);


figure('name', 'Peaks testen')
subplot(2,1,1)
title('Geglättete Daten (M. Rectus femoris (links))')
hold('on')
plot(data_smooth(:,4))
ylim([0, 0.12]);
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')
line ([locs locs], [0 pks], 'color', 'r');

[pks, max_akt] = findpeaks(data_smooth(:,3), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);
subplot(2,1,2) % Rechter Subplot
title('Geglättete Daten (M. Bizeps femoris (links))')
hold('on')
plot(data_smooth(:,3))
ylim([0, 0.12]);
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')
line ([max_akt max_akt], [0 pks], 'color', 'r');

[pks, locs] = findpeaks(data_smooth(:,4), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);


figure('name', 'Peaks testen')
subplot(2,1,1)
title('Geglättete Daten (M. Rectus femoris (rechts))')
hold('on')
plot(data_smooth(:,8))
ylim([0, 0.12]);
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')
line ([locs locs], [0 pks], 'color', 'r');

[pks, max_akt] = findpeaks(data_smooth(:,7), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);
subplot(2,1,2) % Rechter Subplot
title('Geglättete Daten (M. Bizeps femoris (rechts))')
hold('on')
plot(data_smooth(:,7))
ylim([0, 0.12]);
xlabel('Zeit (ms)')
ylabel('Spannung (mV)')
line ([max_akt max_akt], [0 pks], 'color', 'r');
%Maximale Aktivierung der anderen Muskeln

figure('name', 'Maxima')

for muscle = 1 : 4
  [pks, max_akt] = findpeaks(data_smooth(:,muscle), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);
    subplot(4,2,2*(muscle-1)+1) % Linker Subplot
    hold('on')
    plot(data_smooth(:,muscle))
    line ([max_akt max_akt], [0 pks], 'color', 'r');
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    title(subplot_titles_left{muscle})

    [pks, max_akt] = findpeaks(data_smooth(:,muscle+4), 'MinPeakDistance', 5000, 'MinPeakHeight', 0.02);
    subplot(4,2,2*muscle) % Rechter Subplot
    hold('on')
    plot(data_smooth(:,muscle+4))
    xlabel('Zeit (ms)')
    ylabel('Spannung (mV)')
    line ([max_akt max_akt], [0 pks], 'color', 'r');
    title(subplot_titles_right{muscle})

end

% zur auswertung der Daten sind Mittelwerte Spitzenwerte und Standardabweichungen wichtige Parameter
Max_Mean_Sd_integrale = zeros(8, 4);

for muscles = 1 : 8
  Max_Mean_Sd_integrale(muscles, 1) = max(data_filt(:, muscles));
  Max_Mean_Sd_integrale(muscles, 2) = mean(data_filt(:, muscles));
  Max_Mean_Sd_integrale(muscles, 3) = std(data_filt(:, muscles));
  Max_Mean_Sd_integrale(muscles, 4) = trapz(data_filt(:, muscles));
end

Maximum = Max_Mean_Sd_integrale(:, 1);
mittelwerte = Max_Mean_Sd_integrale(:, 2);
stdabweichung = Max_Mean_Sd_integrale(:, 3);

figure('name', 'Maximum')
bar([Maximum(1:4), Maximum(5:8)])
hold('on')
ylabel('Spannung (mV)')
xticklabels({'M. Gastrocnemius medialis', 'M. tibialis anterior', 'M. Bizeps Femoris', 'M. Rectus Femoris'})
legend('Links', 'Rechts')
title('Maximum')

% Fehlerbalken hinzufügen
x_errorbar = 1:4;
m_errorbar = Maximum(1:4);
s_errorbar = stdabweichung(1:4)';
errorbar(x_errorbar, m_errorbar, s_errorbar, 'b')

x_errorbar = 1:4;
m_errorbar = Maximum(5:8);
s_errorbar = stdabweichung(5:8)';
errorbar(x_errorbar, m_errorbar, s_errorbar, 'r')



integrale= Max_Mean_Sd_integrale(:,4);

% Integrale in einer Abbildung plotten
figure('name', 'Integrale')
bar(integrale)
hold('on')
ylabel('Integral')
xticklabels({'M. Gastrocnemius medialis (links)', 'M. tibialis anterior (links)', 'M. Bizeps Femoris (links)', 'M. Rectus Femoris (links)','M. Gastrocnemius medialis (rechts)', 'M. tibialis anterior (rechts)', 'M. Bizeps Femoris (rechts)', 'M. Rectus Femoris (rechts)'})
title('Integral')

