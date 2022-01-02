classdef Packet < handle

    properties
        %start time of process
        start_time = -1
        %end time of process
        end_time = -1
        % expected end time = start_time + duration_time;
        expected_end_time = -1
        %push time of queue
        queue_time
        %process duration of the packet
        duration_time
        % check is started
        is_start = false
    end

    methods

        function obj = Packet(duration)
            obj.queue_time = datetime();
            obj.duration_time = duration;
        end

        function [isfinish, obj] = IsFinish(obj, current_time)

            if ~(obj.is_start)
                isfinish = false;
                return;
            else
                diff_time = seconds(diff(datetime([obj.start_time; current_time])));

                if seconds(obj.end_time) == -1
                    obj.end_time = current_time;
                    obj.expected_end_time = obj.start_time + seconds(obj.duration_time);
                end

                isfinish = diff_time >= obj.duration_time;
            end

        end

        function obj = StartProcess(obj)

            if ~(obj.is_start)
                obj.start_time = datetime();
                obj.is_start = true;
            end

        end

        function [is_started, obj] = IsStarted(obj)
            is_started = obj.is_start;
        end

    end

end
