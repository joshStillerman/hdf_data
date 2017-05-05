pro hdf5_test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pro hdf5_test: mjg started 1/15, this version 1/16
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;compute and plot the first curve (you'll do this to create the plot file)
x = indgen(100)/5.
y0 = beselj(x,0)
plot,x,y0
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
group_name = legend ;chosen for simplicity
plot_graphics = 'black line'
;now add this data group to the file
hdf5_add, x,y0,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics

;compute and plot the 2nd curve
y1 = beselj(x,1)
oplot,x,y1,color=3

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
group_name = legend
plot_graphics = 'red line'
;add this data group to the file
hdf5_add, x,y1,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics


;compute and plot the third curve
y2 = beselj(x,2)
oplot,x,y2,color=4

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
group_name = legend
plot_graphics = 'green line'
;add data group for this trace to file
hdf5_add, x,y2,file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type,$
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type,$
              legend=legend, plot_graphics=plot_graphics


end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;edit to support xyz data VERSION
;probably need more data checking

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The following two routines are used to create data files capturing data
; used in published figures.
;
; For each figure hdf5_new is called to create a new hdf5 file
; with metadata specified in keywords to the routine.
;
; Subsequently;
; each time hdf5_add is called it parses the existing file, 
; adds the new group to the resulting structure and (over)writes a new
; file with the original name.
; data groups contain the data in the figure and accompanying metadata
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro hdf5_add, x,y,z, file=file,group_name=group_name,$
              x_units=x_units,x_axis=x_axis, x_name=x_name,x_type=x_type, $
              y_units=y_units, y_axis=y_axis,y_name=y_name,y_type=y_type, $
              legend=legend, plot_graphics=plot_graphics, $
              verbose=verbose
;add a data group in a file called file.hdf5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;arguments
;x = x axis data 
;y = y data for 1D plots or y axis data for 2D
;if 1D, length of x and y should be equal
;if 2D, size of Z should be nx by ny
;   or x, y and z should all be same (2D) size and shape
;z = optional, z data for 2D plots
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;keywords
;
; file = string (name of hdf5 file - don't include file extension in name)
;
; group_name = string - name of data group
;
; legend = string description of this data group that distinguishes it
;         from other data groups in same plot
;
; plot_graphics = string - optional description of plot style for this data group
;            example 'red filled circles' or 'blue solid line'   
;            similar to what might appear in the figure caption  
;
; x = float or integer array 
; nx = number of elements in x array
; x_units = string
; x_axis = string - label for x axis
; x_name = string - optional longer description of x data
; x_type = string - optional data type
;
; y = float or integer array - should be same size as x
; ny = number of elements in y array
; y_units = string
; y_axis = string - label for y axis
; y_name = string - optional longer description of y data
; y_type = string - optional data type
;
;optionally
; z = float or integer array - should be same size as x
; nz = number of elements in z array
; z_units = string
; z_axis = string - label for z axis
; z_name = string - optional longer description of z data
; z_type = string - optional data type
;
; verbose = set to get more feedback on keywords and arguments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if not keyword_set(file) then file = 'test'
file_name = file+'.hdf5'

h5_struct = h5_parse(file_name,/read)  ;read the file and parse into structure
h5_struct.root.n_groups._data = h5_struct.root.n_groups._data + 1  ;increment to set n_groups

if not keyword_set(group_name) then group_name = 'group'+strtrim(h5_struct.root.n_groups._data,2)
if not keyword_set(legend) then legend = 'legend'+strtrim(h5_struct.root.n_groups._data,2)
if not keyword_set (plot_graphics) then plot_graphics = 'plot graphics metadata not set'

if not keyword_set(x_units) then x_units = ' '
if not keyword_set(x_axis) then x_axis = 'x axis not set'
if not keyword_set(x_name) then x_name = 'x name not set'
if not keyword_set(x_type) then x_type = 'x type not set'

if not keyword_set(y_units) then y_units = ' '
if not keyword_set(y_axis) then y_axis = 'y axis not set'
if not keyword_set(y_name) then y_name = 'y name not set'
if not keyword_set(y_type) then y_type = 'y type not set'

if not keyword_set(z_units) then z_units = ' '
if not keyword_set(z_axis) then z_axis = 'z axis not set'
if not keyword_set(z_name) then z_name = 'z name not set'
if not keyword_set(z_type) then z_type = 'z type not set'

;create data level attribute and data definition structures
xmeta_units = {_name:'x units',_type:'attribute',_data:x_units}  ;structure with attributes
xmeta_axis = {_name:'x axis label',_type:'attribute',_data:x_axis}  ;structure with attributes
xmeta_type = {_name:'x data type',_type:'attribute',_data:x_type}  ;structure with attributes
xmeta_n =  {_name:'nx',_type:'attribute',_data:n_elements(x)}  ;structure with attributes
xdataset = {_name:'x_values', _type:'dataset',_data:x, $
             xmeta_units:xmeta_units,xmeta_axis:xmeta_axis, $
             xmeta_type:xmeta_type,xmeta_n:xmeta_n}  ;structure to add x dataset to group

ymeta_units = {_name:'y units',_type:'attribute',_data:y_units}  ;structure with attributes
ymeta_axis = {_name:'y axis label',_type:'attribute',_data:y_axis}  ;structure with attributes
ymeta_type = {_name:'y data type',_type:'attribute',_data:y_type}  ;structure with attributes
ymeta_n =  {_name:'ny',_type:'attribute',_data:n_elements(y)}  ;structure with attributes
ydataset = {_name:'y_values', _type:'dataset',_data:y, $
             ymeta_units:ymeta_units,ymeta_axis:ymeta_axis, $
             ymeta_type:ymeta_type,ymeta_n:ymeta_n}  ;structure to add y dataset

;create group level metadata structures and group definition structures
legend =  {_name:'legend',_type:'attribute',_data:legend}
plot_meta =  {_name:'group1 plotting information',_type:'attribute',_data:plot_graphics}
group = {_name:group_name,_type:'group',$
           plot_meta:plot_meta,legend:legend,$
           xdataset:xdataset,ydataset:ydataset}

;create root group and create file
root_group = create_struct(group_name,group,h5_struct.root)
h5_create,file_name,root_group

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro hdf5_new, file=file, fig_description=fig_description, fig_source=fig_source, $
              comment=comment, user_fullname=user_fullname, date=date, verbose=verbose
;hdf5_new will create the file and load file metadata 
;(implicitly including the file name)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;keywords
;
;file level metadata
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;add error messages for release
if not keyword_set(file) then file = 'test'
if not keyword_set(fig_description) then fig_description = 'figure description not set'
if not keyword_set(fig_source) then fig_source = 'figure source not set'
if not keyword_set(comment) then comment = 'figure comment not set'
if not keyword_set(user_fullname) then user_fullname = 'user full name not set'
if not keyword_set(date) then date = systime(0)
filename = file+'.hdf5' ;file name
fig_name = file   ;use for root group name
login_info = get_login_info()
user_id = login_info.user_name
n_groups = 0   ;counter for groups of data in plot

;create file level attribute structures
file_user_fullname = {_name:'user_fullname',_type:'attribute',_data:user_fullname}
file_user_id = {_name:'user_id',_type:'attribute',_data:user_id}
file_date = {_name:'date',_type:'attribute',_data:date}
file_fig_description = {_name:'fig_description',_type:'attribute',_data:fig_description}
file_fig_source = {_name:'fig_source',_type:'attribute',_data:fig_source}
file_n_groups = {_name:'n_groups',_type:'attribute',_data:n_groups}

;create root group and create file
root_group = {_name:'root',_type:'group',_comment:comment, $
               file_username:file_user_fullname, file_user_id:file_user_id, file_date:file_date, $
               file_fig_description:file_fig_description,file_fig_source:file_fig_source, $
               file_n_groups:file_n_groups}

h5_create,filename,root_group

end
