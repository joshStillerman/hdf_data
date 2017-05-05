;+
; :Description:
; 
;    Exelis VIS Technical Support example program illustrating
;    an approach to creating a table widget interface to view
;    and modify field values, labeled with the corresponding 
;    structure tag name and data type, for a given IDL structure 
;    variable.
;    
;    For this example to work, the structure field data must be  
;    simple scalar, numerical or string, data type.
; 
; :Author: Exelis VIS Technical Support (ju, 22-jan-2015)
;-
; Event handler
PRO ex_structure_value_table_widget_event, ev
  COMPILE_OPT IDL2
  
  ; Button click
  IF WIDGET_INFO(ev.ID, /UNAME) EQ 'wbtn' THEN BEGIN
    WIDGET_CONTROL, ev.TOP, GET_UVALUE=state
    ntags = N_TAGS( *state.ptr_mystruct )
    WIDGET_CONTROL, state.wt, GET_VALUE=table_vals
    
    ; Update structure with current values in table
    FOR i=0, ntags-1 DO BEGIN
      (*(state.ptr_mystruct)).(i) = table_vals.(i)
    ENDFOR
    PRINT, '> New values for MYSTRUCT:'
    HELP, *state.ptr_mystruct, /STRUCTURES
    PRINT
  ENDIF
  
END
; Main program
PRO ex_structure_value_table_widget
  COMPILE_OPT IDL2
  
  ; Example structure variable "mystruct"
  mystruct = !CONST; Make copy of existing structure variable
  
  PRINT, '> Original values for MYSTRUCT:'
  HELP, mystruct, /STRUCTURES
  PRINT
  
  ntags = N_TAGS(mystruct)
  wb = WIDGET_BASE(/col, TITLE='MYSTRUCT field values')
  wt = WIDGET_TABLE(wb, XSIZE=1, YSIZE=ntags, $
    COLUMN_WIDTHS=[200], /COLUMN_MAJOR, $
    /RESIZEABLE_COLUMNS, /EDITABLE)  ; allow cells to be editable
  str = '(* Tab or click on a different field to register your ' $
    +'field value changes *)'
  wlbl = WIDGET_LABEL(wb, VALUE=str, FONT='Arial*italic*14')
  str = 'Commit Table Values to Structure'
  wbtn = WIDGET_BUTTON(wb, VALUE=str, UNAME='wbtn')
  ; Get tag names and IDL data type to populate row labels
  tagnams = TAG_NAMES(mystruct)
  FOR i=0, ntags-1 DO BEGIN
    tagnams[i] = tagnams[i] $
      + ' (' + STRLOWCASE( SIZE(mystruct.(i), /TNAME) ) + ')'
  ENDFOR
  WIDGET_CONTROL, wt, ROW_LABELS=tagnams
  WIDGET_CONTROL, wt, COLUMN_LABELS=['STRUCTURE FIELD VALUES']
  
  WIDGET_CONTROL, wb, /realize
  ptr_mystruct = PTR_NEW(mystruct)
  
  ; state structure
  state = { $
    wt : wt, $  ; table widget reference
    ptr_mystruct : ptr_mystruct $  ; pointer to the original structure
  }
  WIDGET_CONTROL, wb, SET_UVALUE=state
  
  ; Populate table widget with structure field values
  WIDGET_CONTROL, wt, SET_VALUE=mystruct 
  XMANAGER, 'ex_structure_value_table_widget', wb
END
