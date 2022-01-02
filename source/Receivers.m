classdef Receivers < handle

    properties
        receivers = []
        no_receivers = 0
        receiver_queue_size = -1
    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Receivers(number_of_receivers, queue_size)
            obj.no_receivers = number_of_receivers;
            obj.receiver_queue_size = queue_size;

            if obj.no_receivers > 0

                for i = 1:obj.no_receivers
                    obj.receivers = [obj.receivers, Queue(obj.receiver_queue_size)];
                end

            end

        end

        function [is_push, obj] = Push(obj, receiver_index, packet)

            if receiver_index > obj.no_receivers
                is_push = false;
            else
                is_push = obj.receivers(receiver_index).Push(packet);
            end

        end

    end

end
