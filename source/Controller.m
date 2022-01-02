classdef Server < handle

    properties
        is_busy = false
        idle = 0
        packet = null

    end

    methods
        % if size_of_queue == -1, that means no limit for queue it can push inifinity times
        function obj = Server()
            obj.is_busy = false;
            obj.is_finish = false;
            obj_idle = 0;
        end

        function [is_push, obj] = PushToServer(obj, packet)

            if obj.is_busy == false
                obj.packet = packet
                is_push = true
                idle = idle + 1;
                obj.is_busy = true;
                return;
            else

                if obj.packet.IsFinish()
                    idle = idle + 1;
                    obj.is_busy = true;
                    obj.packet = packet;
                    is_push = true;
                else
                    is_push = false;
                end

            end

            function [is_finish, obj] = IsBusy(obj, packet)

                if packet.IsFinish()
                    obj.is_busy = false;
                end

                is_finish = obj.is_busy;

            end

            function [idle_no, obj] = GetIdle(obj)
                return obj.idle;
            end

        end

    end
