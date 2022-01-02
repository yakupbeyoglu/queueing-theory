classdef Server < handle

    properties
        is_busy = false
        idle = 0
        packet

    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Server()
            obj.is_busy = false;
            obj.idle = 0;
        end

        function [is_push, obj] = PushToServer(obj, packet)

            if obj.is_busy == false
                obj.packet = packet
                obj.packet.StartProcess();
                is_push = true
                obj.idle = obj.idle + 1;
                obj.is_busy = true;
                return;
            else

                if obj.packet.IsFinish(datetime())
                    obj.idle = obj.idle + 1;
                    obj.is_busy = true;
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
