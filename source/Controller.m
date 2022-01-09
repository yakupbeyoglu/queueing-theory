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
            for i=1:obj.no_package
                obj.queue.Push(Packet(randi([1,2]))); 
            end
        end

        function obj = Process(obj)
            start_time = datetime();
            process_packet = 0;
            processed_packet = 0;
            push_time = datetime();
            wait_time = 1 - exp(-1 * obj.lambda_queue * processed_packet);
            obj.queue = Queue(-1);
            for i=1:length(obj.receivers.receivers)
                obj.receivers.receivers(i).idle = 0;
            end
            while process_packet < obj.no_package || processed_packet <= obj.no_package

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
                            obj.queue.Pop();
                            processed_packet = processed_packet + 1;
                        end
                    end

                end
                
            end
            for i=1:length(obj.receivers.receivers)
                disp("id = " + obj.receivers.receivers(i).id + " idle = " + obj.receivers.receivers(i).idle);
            end
            end_time = datetime();
            disp(start_time);
            disp(end_time);
        end

    end

end
