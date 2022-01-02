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
                    is_push = true;
                    %To Do : 
                    % if length(obj.elements) == 1
                    % obj.elements.StartProcess(datetime())
                    % To Do : 
                    % if obj.elements(0).IsFinish()
                    % obj.elements(0).Pop

                end

            end

        end

        % pop first element of queue
        function obj = Pop(obj, packet)

            if length(obj.elements) > 0
                obj.elements = obj.elements(2:end);
            end

        end

        function [is_empty, obj] = IsEmpty(obj)
            is_empty = length(obj.elements) == 0
        end

        function [queue_length, obj] = GetLength(obj)
            queue_length = length(obj.elements);
        end

    end

end
