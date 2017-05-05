pro hdf5_test
; test writing hdf5 files
; aim is to prepare for open-access data requirement
; simplest idl interface requires creation of a hierarchical structure
; containing all information; then file is created by single call
; to 'h5_create' function
; seems simpler than individual calls to add elements with
; multiple opens and closes

;create 2 routines  hdf5_new.pro  hdf5_add

;hdf5_new will create the file and load file metadata including the
;file name

;hdf5_add will add a data group
;each time hdf5_add is called it parses, adds the new group to the
;resulting structure and writes a new file with the original name


;need to figure out best way to do user interface
;must put all of the input data into a structure:
;does user input as keywords or as structure? 
;need extensive input data checking before commands are executed

;provide examples for users (in either case - keywords or structure)

;input = {filename:filename,$       ;string
;         filecomment:filecomment,$ ;string

;what should the user interface look like?
;input as keywords?  structure?
;how to handle multiple, but unknown number of data groups?

file = 'fig_4'
filename = file+'.hdf5' ;file name
fig_name = file   ;root group name
;file level metadata
comment = 'This is a test of a schema for figure data'
name = 'John Doe'
userid = 'jxd'
fig_source = 'JA-15-1234.doc  Fig. 4'
fig_description = 'height of bouncing ball vs time'
n_groups = 2   ;groups of data in plot
;rank = 1

;data
x = findgen(100)
y1 = sin(x/10.)
y2 = 1-y1

;data level metadata
x_units = 'sec'
x_axis = 'Time (sec)'
y_units = 'm'
y_axis = 'Height (m)'

;group level metadata
legend_1 = 'Sine wave'
comment_1 = 'This is a Sine Wave'
plot1_graphics = 'red circles'
legend_2 = '1/Sin'
comment_2 = 'This data is 1/Sine'
plot2_graphics = 'blue squares'

;create data level attribute and data definition structures
xmeta_units = {_name:'x units',_type:'attribute',_data:x_units}  ;structure with attributes
xmeta_axis = {_name:'x axis label',_type:'attribute',_data:x_axis}  ;structure with attributes
xdataset = {_name:'x_values', _type:'dataset',_data:x, $
             xmeta_units:xmeta_units,xmeta_axis:xmeta_axis}  ;structure to add x dataset to group

ymeta_units = {_name:'y units',_type:'attribute',_data:y_units}  ;structure with attributes
ymeta_axis = {_name:'y axis label',_type:'attribute',_data:y_axis}  ;structure with attributes
ydataset1 = {_name:'y_values', _type:'dataset',_data:y1, $
             ymeta_units:ymeta_units,ymeta_axis:ymeta_axis}  ;structure to add y dataset
ydataset2 = {_name:'y_values', _type:'dataset',_data:y2, $
             ymeta_units:ymeta_units,ymeta_axis:ymeta_axis}  ;structure to add y dataset

;for i = 0,n_groups-1 do begin

;create group level metadata structures and group definition structures
legend1 =  {_name:'legend 1',_type:'attribute',_data:legend_1}
legend2 =  {_name:'legend 2',_type:'attribute',_data:legend_2}
plot_meta =  {_name:'group1 plotting information',_type:'attribute',_data:plot1_graphics}
group1 = {_name:'shot1',_type:'group',_comment:comment_1,$
           plot_meta:plot_meta,legend1:legend1,$
           xdataset:xdataset,ydataset:ydataset1}

plot_meta =  {_name:'group2 plotting information',_type:'attribute',_data:plot2_graphics}
group2 = {_name:'shot2',_type:'group',_comment:comment_2,$
          legend2:legend2, plot_meta:plot_meta,$
          xdataset:xdataset,ydataset:ydataset2}

;create file level attribute structures
file_username = {_name:'user_name',_type:'attribute',_data:name}
file_userid = {_name:'userid',_type:'attribute',_data:userid}
file_fig_description = {_name:'fig_description',_type:'attribute',_data:fig_description}
file_fig_source = {_name:'fig_source',_type:'attribute',_data:fig_source}
file_n_groups = {_name:'n_groups',_type:'attribute',_data:n_groups}

;create root group and create file
root_group = {_name:fig_name,_type:'group',_comment:comment, $
               file_username:file_username, file_userid:file_userid, $
               file_fig_description:file_fig_description,file_fig_source:file_fig_source, $
               file_n_groups:file_n_groups, $
               group1:group1, group2:group2}

h5_create,filename,root_group

end
