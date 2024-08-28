import os

def remove_empty_directories(directory):
    for dirpath, dirnames, filenames in os.walk(directory, topdown=False):
        if not dirnames and not filenames:
            print(f"Removing empty directory: {dirpath}")
            os.rmdir(dirpath)

directory = "/QRISdata/Q7361/SRRIDS/fastqfilesncbi"
remove_empty_directories(directory)