#!/usr/bin/python
import h5py
import sys
 
def display_hdf(file_name) :
    """Prints the HDF5 file structure"""
    file = h5py.File(file_name, 'r') # open read-only
    item = file #["/Configure:0000/Run:0000"]
    print_hdf5_item_attributes(item)
    print_hdf5_item_structure(item)
    file.close()
def print_hdf5_item_attributes(item, offset=''):
    for attr in item.attrs.items():
        print offset+str(attr)
        
def print_hdf5_item_structure(g, offset='    ') :
    """Prints the input file/group/dataset (g) name and begin iterations on its content"""
    if   isinstance(g,h5py.File) :
        print g.file, '(File)', g.name
 
    elif isinstance(g,h5py.Dataset) :
        print '(Dataset)', g.name, '    len =', g.shape #, g.dtype
 
    elif isinstance(g,h5py.Group) :
        print '(Group)', g.name
 
    else :
        print 'WORNING: UNKNOWN ITEM IN HDF5 FILE', g.name
        sys.exit ( "EXECUTION IS TERMINATED" )
    print_hdf5_item_attributes(g, offset+'     ')
 
    if isinstance(g, h5py.File) or isinstance(g, h5py.Group) :
        for key,val in dict(g).iteritems() :
            subg = val
            print offset, key, #,"   ", subg.name #, val, subg.len(), type(subg),
            print_hdf5_item_structure(subg, offset + '    ')
 
if __name__ == "__main__" :
    filename = sys.argv[1]
    display_hdf(filename)
