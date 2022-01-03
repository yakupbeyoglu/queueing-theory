classdef Controller < handle

    properties
        % k is number of receivers
        k = 1

        % no_package is number of total packets
        no_package = 100

        receivers
        queue
        storage
    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Controller(k, no_package)
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

            while obj.queue.GetLength() > 0
                available = obj.receivers.GetAvailableIndex();

                if ~(available == -1)
                    first_element = obj.queue.GetFirstElement();

                    if ~(first_element == -1)
                        is_push = obj.receivers.Push(available, first_element);

                        if is_push
                            obj.queue.Pop();
                        end

                    end

                end

            end

            end_time = datetime();
            disp(start_time);
            disp(end_time);
        end

    end

end
