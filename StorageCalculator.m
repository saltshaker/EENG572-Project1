function [batLevel, thermLevel, excessLevel] = StorageCalculator(delta, prev) 
    batMax = 250;
    thermMax = 70;
    batEff = 0.99;
    thermEff = 0.6;

    if delta >= 0    % Energy surplus
        if delta > (batMax - prev.bat) * (1 + 1 - batEff)       % More energy than battery space
            batLevel = prev.bat + batMax - prev.bat;
            delta = delta - ((batMax - prev.bat) * (1 + 1 - batEff));
        else        % All of delta goes into battery
            batLevel = prev.bat + delta;
            delta = 0;
        end
        if delta > (thermMax - prev.therm) * (1 + 1 - thermEff) % More energy than thermal space
            thermLevel = prev.therm + (thermMax - prev.therm);
            delta = delta - ((thermMax - prev.therm) * (1 + 1 - thermEff));
            excessLevel = prev.excess + delta;
        else        % All of remaining delta goes into thermal
            thermLevel = prev.therm + delta;
            excessLevel = prev.excess;
        end
    else            % Energy deficit
        if abs(delta) > prev.bat         % More demand than energy stored in battery
            batLevel = 0;
            delta = delta + prev.bat;
        else        % Battery fulfills all of demand
            batLevel = prev.bat + delta;
            delta = 0;
        end
        if abs(delta) > prev.therm       % More remaining demand than energy stored in thermal
            thermLevel = 0;
            delta = delta + prev.therm;
            excessLevel = prev.excess + delta;
        else        % Thermal fulfills all of remaining demand
            thermLevel = prev.therm + delta;
            excessLevel = prev.excess;
        end
    end
end