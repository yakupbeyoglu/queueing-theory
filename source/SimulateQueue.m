function SimulateQueue(no_package)
    s1 = Simulation(1, no_package);
    s2 = Simulation(4, no_package);
    s1.Process();
    s2.Process();
    PlotXYCompare(s1.total_duration, s2.total_duration, s1.total_queue_time, s2.total_queue_time, "duration(seconds)", "total queue time", "Total queue time of k=1 & k= 4");
    PlotXYCompare(s1.total_duration, s2.total_duration, s1.avarage_waiting_time, s2.avarage_waiting_time, "duration(seconds)", "avarage waiting time", "Avarage waiting time of k=1 & k= 4");
    PlotXYCompare(s1.total_duration, s2.total_duration, s1.avarage_number_of_customer_waiting_in_queue ...
        , s2.avarage_number_of_customer_waiting_in_queue, "duration(seconds)", "avarage number of customer wait in queue", "Avarage number of customer waiting in queue of k=1 & k= 4");
    PlotXYCompare(s1.total_duration, s2.total_duration, s1.avarage_server_load, s2.avarage_server_load, "duration", "avarage server load", "Avarage server load of k=1 & k= 4");
    PlotXYCompare(no_package, no_package, s1.total_duration, s2.total_duration, "number of package", "duration(seconds)", "Duration of k=1 & k= 4");

    clear();
end
