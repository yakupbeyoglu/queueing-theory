classdef Server < handle

    properties
        id = 0
        is_busy = false
        idle = 0
        packet
        old_packets = []

        %lambda_process = events/process in the queue, default 1/60
        lambda_process = 0.016

    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Server(id)
            obj.id = id;
            obj.is_busy = false;
            obj.idle = 0;
        end

        function [is_push, obj] = PushToServer(obj, p_packet)
            poisson_dis = 1 - exp(-1 * obj.lambda_process * obj.idle);
            if obj.is_busy == false
                packet = p_packet;
                packet.duration_time = poisson_dis;
                obj.packet = packet
                disp(packet);
                is_push = true
                obj.idle = obj.idle + 1;
                obj.is_busy = true;
                return;
            else

                if obj.packet.IsFinish(datetime())
                    obj.idle = obj.idle + 1;
                    obj.is_busy = true;
                    packet = p_packet;
                    packet.duration_time = poisson_dis;
                    obj.packet = packet;
                    obj.packet.StartProcess();
                    is_push = true;
                else
                    is_push = false;
                end

            end

        end

        function [is_finish, obj] = IsBusy(obj)

            if obj.is_busy

                if obj.packet.IsFinish(datetime())
                    obj.old_packets = [obj.old_packets, obj.packet];
                    obj.is_busy = false;
                end

            end

            is_finish = obj.is_busy;

        end

        function [idle_no, obj] = GetIdle(obj)
            idle_no = obj.idle;
        end

    end

end
