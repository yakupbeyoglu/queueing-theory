classdef Queue < handle

    properties
        elements = []
        queue_size = -1;
    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Queue(size_of_queue)
            obj.queue_size = size_of_queue;
        end

        function [is_push, obj] = Push(obj, packet)

            if obj.queue_size == -1
                obj.elements = [obj.elements, packet];
            else

                if length(obj.elements) > obj.queue_size
                    is_push = false;
                else
                    obj.elements = [obj.elements, packet];
                end

            end

        end

        % pop first element of queue
        function obj = Pop(obj, packet)

            if length(obj.elements) > 0
                obj.elements = obj.elements(2:end);
            end

        end

        function [isempty, obj] = IsEmpty(obj)
            isempty = length(obj.elements) == 0
        end

    end

end
