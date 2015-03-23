% =====================================================================
%> @brief xplot plots lines with markers better than original one
%>
%> @param vector values to plot (vector)
%> @param line    line color and shape
%> @param marker  marker color and shape
%> @retval out return value of this method
% =====================================================================
function[] = xplot(rec_obj,vector, line, marker)

plot(vector, line);
x = 1:round(length(vector)/20):length(vector);
hold on;
plot(x, vector(x), marker);
