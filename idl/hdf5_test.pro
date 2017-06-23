pro hdf5_test,ps=ps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pro hdf5_test: mjg started 1/15, this version 7/16
;this routine provides an example for writing hdf5 data
;as required by the new open-access requirement
;
;we assume that a routine like this would create the figure files, 
;typically in ps, at the same time (but that code is not shown)
;this routine calls hdf5_new and hdf5_add, which package
;idl native routines
;
;metadata is specified at three levels
;file level - describing the figure
;group level - corresponding to a trace or data group in the figure
;            - typically each element in a figure legend would have
;            - its own group
;data level - metadata on each x, y or z array in each group
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;these are keywords that will be passed to the routines that create the hdf5 file
;users will need to supply them or define them in their plotting routines
;
;keywords for file level metadata
;
;file = string - name of hdf5 file you wish to write (don't include
;                file extension in name
;                example:  if file='fig_3' then filename will be fig_3.hdf5
;
;fig_description = string describing figure (could be caption for manuscript)
;
;fig_source = string - identifies which manuscript/paper the figure is part of
;             examples:  'JA-14-21' or  'NF 55 023012 2015'
;
;comment = string - anything else you want to say about the figure
;
;user_fullname =  string - full name of person creating file
;
;verbose = set to get more feedback on keywords and arguments
;
;date = date when this hdf5 file was created
;
;
;keywords for group level metadata
;
;group_name = string, name for each trace or plot element, typically could
;             be the plot legend if that is present and unambiguous
;
;legend = string used for group in the legend on the plot
;         best if it exactly matched what was on the plot
;
;plot_graphics = string containing any special information that will 
;                identify or characterize plot (color, line type, symbol, etc.) 
;
;keywords for data level metadata
;
;x_units, y_units, z_units = string containing units for each 
;
;x_axis, y_axis, z_axis = string containing axis labels as they are
;                         on each graph
;
;x_type, y_type, z_type = string containing data type (integer, float, etc.)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;specify hdf5 file level metadata
file = 'Fig_1'
fig_description = 'Besel Functions J0, J1 and J2' 
fig_source = 'Phys. Plasmas 17, 1234 2010'
comment = 'This is the way the ball bounces'
user_fullname = 'John Doe'
date = systime(0)

;start a new hdf5 file
hdf5_new, file=file, fig_description=fig_description, fig_source=fig_source, $
              comment=comment, user_fullname=user_fullname,date=date

;set up a simple color table (just for plotting)
r = [000,255,255,000,000]
g = [000,255,000,000,255]
b = [000,255,000,255,000]
tvlct,r,g,b

print,file+'.ps'
help,keyword_set(ps)
if keyword_set(ps) then begin
  print,'ps'
  set_plot,'ps'
  !p.charthick=5
  !p.thick = 5
  !x.thick = 4
  !y.thick = 4
  device,/color,bits=8,/portrait,file=file+'.ps'
  device,set_font='helvetica',font_index=20
  !p.font = 0
endif else begin
  print,'x'
  !p.charthick=1
  !p.thick = 1
endelse

;define metadata for 1st data trace/group 
x_units = 's'
x_axis = 'time (s)'
x_name = 'measured with a stopwatch'
x_type = 'float'

y_units = 'm'
y_axis = 'height (m)'
y_name = 'measured with a ruler'
y_type = 'float'

legend = 'J0'

;compute and plot the first curve (you'll do this to create the plot file)
x = indgen(100)/5.
y0 = beselj(x,0)
plot,x,y0,charsize=1.8,title=fig_description,xtitle=x_axis,ytitle=y_axis,color=0
xyouts,/norm,.85,.85,legend,size=1.8

group_name = legend ;chosen for simplicity
plot_graphics = 'black line'
;now add this data group to the hdf5 file
hdf5_add, x,y0,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics

;define metadata for 2nd trace/data group
x_units = 's'
x_axis = 'time (s)'
x_name = 'measured with a stopwatch'
x_type = 'float'

y_units = 'm'
y_axis = 'height (m)'
y_name = 'measured with a ruler'
y_type = 'float'

legend = 'J1'

;compute and plot the 2nd curve
y1 = beselj(x,1)
oplot,x,y1,color=2
xyouts,/norm,.85,.8,legend,size=1.8,color=2

group_name = legend
plot_graphics = 'red line'
;add this data group to the file
hdf5_add, x,y1,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics


;define metadata for third group/trace 
x_units = 's'
x_axis = 'time (s)'
x_name = 'measured with a stopwatch'
x_type = 'float'

y_units = 'm'
y_axis = 'height (m)'
y_name = 'measured with a ruler'
y_type = 'float'

legend = 'J2'

;compute and plot the third curve
y2 = beselj(x,2)
oplot,x,y2,color=4
xyouts,/norm,.85,.75,legend,size=1.8,color=4

group_name = legend
plot_graphics = 'green line'
;add data group for this trace to file
hdf5_add, x,y2,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics

if keyword_set(ps) then begin
  device,/close
  !p.charthick=1
  !p.thick = 1
  !x.thick = 1
  !y.thick = 1
  !p.font = -1
  set_plot,'x'
  ps = 0
endif

end
