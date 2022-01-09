classdef Receivers < handle

    properties
        receivers = []
        no_receivers = 0
    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Receivers(number_of_receivers)
            obj.no_receivers = number_of_receivers;

            if obj.no_receivers > 0

                for i = 1:obj.no_receivers
                    obj.receivers = [obj.receivers, Server(i)];
                end

            end

        end

        function [is_push, obj] = Push(obj, receiver_index, packet)

            if receiver_index > obj.no_receivers
                is_push = false;
            else
                is_push = obj.receivers(receiver_index).PushToServer(packet);
            end

        end

        % if all servers are busy return -1
        function [available_index, obj] = GetAvailableIndex(obj)
            min_idle = obj.receivers(1).GetIdle();
            index = 1;
            all_busy = true;

            for i = 1:obj.no_receivers
                temp = obj.receivers(i).GetIdle();

                if ~(obj.receivers(i).IsBusy())

                    if (temp <= min_idle)
                        min_idle = temp;
                        index = i;
                        all_busy = false;
                    end

                end

            end

            if all_busy
                available_index = -1;
            else
                available_index = index;
            end

        end

    end

end
