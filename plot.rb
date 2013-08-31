require("gnuplot");

N_POINTS = 200;
TITLE = nil;
XLABEL = nil;
YLABEL = nil;

# one big ugly subroutine
def plot_(funcs, titles, a, b, ymin, ymax, nPoints, xlabel, ylabel)
    if(b < a) then
        return nil;
    end
    if nPoints < 2 then
        return nil;
    end
    width = (b.to_f()-a.to_f())/(nPoints.to_f()-1);
    x = (0..(nPoints-1)).map {|i| a+i*width};
    Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
            plot.xrange("["+a.to_s()+":"+b.to_s()+"]");
            if (not ymin == nil) and (not ymax == nil) then
                plot.yrange("["+ymin.to_s()+":"+ymax.to_s()+"]");
            end
            if not xlabel == nil then
                plot.xlabel(xlabel);
            end
            if not ylabel == nil then
                plot.ylabel(ylabel);
            end
            for i in (0..(funcs.length()-1))
                f = funcs[i];
                title = titles[i];
                y = x.map {|c| f.call(c)};
                plot.data << Gnuplot::DataSet.new([x, y]) do |ds|
                    ds.with = "lines";
                    if title == nil then
                        ds.notitle();
                    else
                        ds.title = title;
                    end
                end
            end
        end
    end
end

def plot(funcs, a, b, ymin, ymax)
    if funcs.class() == Array then
        titles = (1..funcs.length()).map {|i| "f"+i.to_s()+"(x)"};
        return plot_(funcs, titles, a, b, ymin, ymax,
                     N_POINTS, XLABEL, YLABEL);
    else
        return plot_([funcs], ["f(x)"], a, b, ymin, ymax,
                     N_POINTS, XLABEL, YLABEL);
    end
end
