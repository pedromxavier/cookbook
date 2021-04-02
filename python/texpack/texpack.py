import re
import os
import argparse
import pathlib
import shutil

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('fname', type=str, action='store')
    args = parser.parse_args()

    file_name = pathlib.Path(args.fname).absolute()
    file_dir = file_name.parent.absolute()

    

    gname = os.path.basename(fname)
    bname, _ = os.path.splitext(gname)

    ## Get Local Packages
    RE_REQPKG = re.compile(r"\\RequirePackage\{(\.{1,2}\/.*)\}", re.UNICODE)
    RE_USEPKG = re.compile(r"\\usepackage\{(\.{1,2}\/.*)\}", re.UNICODE)

    with open(fname, 'r', encoding='utf-8') as file:
        source = file.read() 

    packs = [*RE_REQPKG.findall(source), *RE_USEPKG.findall(source)]

    dname = f'texpack-{bname}'

    os.mkdir(dname)

    for pack in packs:
        
        source = source.replace(pack, f"./{pack.split(r'/')[-1]}")
    
        with open(pack) as file:
            file.read()

        with open(os.path.join(dname, gname), 'r') as file:
            file.write(source)


if __name__ == "__main__":
    main()
