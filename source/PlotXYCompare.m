function PlotXYCompare(x_value1, x_value2, y_value1, y_value2, x_title, y_title, figure_name)
    f = figure;
    f.Name = figure_name;
    x1 = [0, x_value1];
    y1 = [0, y_value1];
    x2 = [0, x_value2];
    y2 = [0, y_value2];
    plot(x1, y1);
    hold on;
    plot(x2, y2);
    xlabel(x_title);
    ylabel(y_title);
    title(figure_name);
end
