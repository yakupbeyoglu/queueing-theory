classdef Simulation < handle

    properties
        % k is number of receivers
        k = 1

        % no_package is number of total packets
        no_package = 100
        %lambda_queue = events/seconds in the queue, defualt 2/60seconds
        lambda_queue = 0.033
        %lambda_process = events/process in the queue, default 1/60
        lambda_process = 0.016
        receivers
        queue
        storage
        old_packages = []
        total_queue_time = 0
        total_duration = 0
        avarage_waiting_time = 0
        avarage_number_of_customer_waiting_in_queue = 0
        avarage_server_load = 0
    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Simulation(k, no_package)
            obj.k = k;
            obj.no_package = no_package;
            obj.receivers = Receivers(k);
        end

        function obj = InitializeQueue(obj)
            obj.queue = Queue(-1);

            for i = 1:obj.no_package
                obj.queue.Push(Packet(randi([1, 2])));
            end

        end

        function obj = Process(obj)
            start_time = datetime();
            process_packet = 0;
            processed_packet = 0;
            push_time = datetime();
            wait_time = 1 - exp(-1 * obj.lambda_queue * processed_packet);
            obj.queue = Queue(-1);

            for i = 1:length(obj.receivers.receivers)
                obj.receivers.receivers(i).idle = 0;
            end

            while process_packet < obj.no_package - 1 || processed_packet <= obj.no_package - 1

                if process_packet == 0
                    push_time = datetime();
                    obj.queue.Push(Packet(20));
                    process_packet = process_packet + 1;
                else

                    if seconds(diff(datetime([push_time; datetime()]))) >= wait_time
                        wait_time = 1 - exp(-1 * obj.lambda_queue * processed_packet);
                        obj.queue.Push(Packet(20));
                        process_packet = process_packet + 1;
                    end

                end

                available = obj.receivers.GetAvailableIndex();

                if ~(available == -1)
                    first_element = obj.queue.GetFirstElement();

                    if ~(first_element == -1)
                        is_push = obj.receivers.Push(available, first_element);

                        if is_push
                            first_element.start_time = datetime();
                            obj.old_packages = [obj.old_packages, first_element];
                            obj.queue.Pop();
                            processed_packet = processed_packet + 1;
                        end

                    end

                end

            end

            for i = 1:length(obj.receivers.receivers)
                disp("id = " + obj.receivers.receivers(i).id + " idle = " + obj.receivers.receivers(i).idle);
            end

            end_time = datetime();
            disp(start_time);
            disp(end_time);
            total_duration = seconds(diff(datetime([start_time; end_time])));
            disp("total duration = " + total_duration);
            lambda = obj.no_package / total_duration;
            disp("lambda = " + lambda);
            server_load = 0;

            for i = 1:length(obj.receivers.receivers)
                disp("id = " + obj.receivers.receivers(i).id + " idle = " + obj.receivers.receivers(i).idle + " U = " + obj.receivers.receivers(i).idle / total_duration + " server_load = " + obj.receivers.receivers(i).total_process_time / total_duration);
                server_load = server_load + obj.receivers.receivers(i).total_process_time / total_duration;
            end

            disp(obj.old_packages);

            time = 0;
            no_customer = 0;

            for i = 1:length(obj.old_packages)
                disp(datetime(obj.old_packages(i).queue_time));
                disp("end");
                disp(datetime(obj.old_packages(i).start_time));
                time_diff = seconds(diff(datetime([obj.old_packages(i).queue_time; obj.old_packages(i).start_time])));
                disp("diff = " + time_diff);

                if (time_diff > 0.05)
                    time = time + time_diff;
                    no_customer = no_customer + 1;
                end

            end

            obj.total_queue_time = time;
            obj.total_duration = total_duration;
            obj.avarage_waiting_time = time / total_duration;
            obj.avarage_number_of_customer_waiting_in_queue = no_customer / length(obj.old_packages);
            obj.avarage_server_load = server_load / obj.k;
            disp("total_queue_time = " + obj.total_queue_time);
            disp("total duration = " + obj.total_duration);
            disp("avarage waiting time = " + obj.avarage_waiting_time);
            disp("avarage number of customer in queue = " + obj.avarage_number_of_customer_waiting_in_queue);
            disp("Avarage serverload = " + obj.avarage_server_load);

        end

    end

end
