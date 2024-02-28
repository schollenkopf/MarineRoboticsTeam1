function [thrust_data,time_data] = thrust_parsing(bagselect,thrust_topic)

bSel_thrust = select(bagselect, 'Topic', thrust_topic);
msgStructs_thrust = readMessages(bSel_thrust, 'DataFormat', 'struct');
time_data = bSel_thrust.MessageList.Time;
thrust_data = cellfun(@(m) double(m.Data), msgStructs_thrust);

end

