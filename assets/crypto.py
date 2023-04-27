#!/usr/bin/python -u

import argparse
import tarfile
import os.path
import sys
# import random


# file_dec = "output/word-dec.tar.gz";
# # file_enc = "word-enc.tar.gz";
# # file_dec = "output/word";
# file_enc = "output/word.db";
# file_rev = "output/word-rev.tar.gz";
# # file_source = ["test.txt"];
# file_source = ["word.db","sense.db","thesaurus.db"];

class Task:
    def __init__(self, source,target, chunksize):
        self.target = target
        self.source = source
        self.chunksize = chunksize

    def is_callable(self, method_name):
        return hasattr(self, method_name) and callable(getattr(self, method_name))

    def dynamic_call(self, method_name):
        return getattr(self, method_name)() 

    # def make_tarfile(output, source):
    #     with tarfile.open(output, "w:gz") as tar:
    #         tar.add(source, arcname=os.path.basename(source))

    def archive(self):
        """ py crypto.py archive -s tmp/word.db tmp/sense.db tmp/thesaurus.db """
        with tarfile.open(self.target, "w:gz") as tar:
            for name in self.source:
                print(name)
                tar.add(name, arcname=os.path.basename(name))

    def encrypt(self):
        """py crypto.py encrypt -s output/word -t output/word.db"""
        source = open(self.source[0],'rb')
        target = open(self.target, 'wb')

        # byteToStr = data.decode('Latin-1')
        # byteToHex = data.hex(sep=' ')
        # byteToInt = int.from_bytes(data,byteorder=sys.byteorder,signed=True)
        
        # bytes
        blob = list(source.read(self.chunksize))
        # keyMax = 255 -max(blob[0:2])
        # key = random.randrange(0, keyMax)

        x = 340
        k0= blob[0]
        k1= blob[1]
        y = k0 + k1

        print('working', x, y)

        if(y > x):
            # blob[0] = 255 - k0
            # blob[1] = 255 - k1
            print('already done')
            return
        else:
            blob[0] = 255 ^ k0
            blob[1] = 255 ^ k1
            print('done',blob[0],blob[1])

        data = bytes([i for i in blob])

        while data:
            target.write(data)
            data = source.read(self.chunksize)
        target.close()
        source.close()

    def decrypt(self):
        """py crypto.py decrypt -s output/word.db -t output/word.tar.gz"""
        source = open(self.source[0],'rb')
        target = open(self.target, 'wb')

        blob = list(source.read(self.chunksize))

        x = 339
        k0= blob[0]
        k1= blob[1]

        # 355: zip 340: tar
        y = k0 + k1

        print('working', x, y)

        if(y > x):
            blob[0] = 255 - k0
            blob[1] = 255 - k1
            print('done',blob[0],blob[1])
        else:
            # blob[0] = 255 ^ k0
            # blob[1] = 255 ^ k1
            print('already done')
            return

        data = bytes([i for i in blob])

        while data:
            target.write(data)
            data = source.read(self.chunksize)
        target.close()
        source.close()

    def help(self):
        help(crypto)

# create_archive(file_dec,file_source)
# create_encrypt(file_enc,file_dec)
# create_decrypt(file_rev,file_enc)


parser = argparse.ArgumentParser(
    prog = 'crypto',
    description = '[tar.gz zip] crypto',
    epilog =  "..."
)

# parser.add_argument('filename')           # positional argument
# parser.add_argument('-c', '--count')      # option that takes a value
# parser.add_argument('-v', '--verbose', action='store_true')  # on/off flag
# args = parser.parse_args()
# print(args.filename, args.count, args.verbose)


# py crypto.py archive -s word.db sense.db thesaurus.db 
# py crypto.py encrypt -s output/word -t output/word.db
# py crypto.py decrypt -s output/word.db -t output/word.tar.gz
parser.add_argument(
    'task', 
    # metavar='T', 
    # type=str, 
    # nargs='+',
    help='name of task [archive, encrypt, decrypt]',
)
parser.add_argument(
    '-s',
    '--source',
    # metavar='T', 
    type=str, 
    nargs='+',
    # default=['output/word-dec.tar.gz'],
    # default=["word.db","sense.db","thesaurus.db"],
    help='source/input file'
)
parser.add_argument(
    '-t',
    '--target',
    default='output/word',
    help='target/output file'
)
parser.add_argument(
    '-cs',
    '--chunksize',
    type=int, 
    default=1028*1028,
    help='chunksize'
)

# parser.add_argument(
#     'integers', 
#     metavar='N', 
#     type=int, 
#     nargs='+',
#     help='an integer for the accumulator'
# )
# parser.add_argument(
#     '--sum', 
#     dest='accumulate', 
#     action='store_const',
#     const=sum, 
#     default=max,
#     help='sum the integers (default: find the max)'
# )

args = parser.parse_args()
# print(args.accumulate(args.integers))

print('starting')
# print('task',args.task)
# print('source',args.source)
# print('target',args.target)
# print('chunksize',args.chunksize)

crypto = Task(args.source,args.target,args.chunksize)

if (crypto.is_callable(args.task) == False):
    print('try -h')
    sys.exit()

# print('yes')
crypto.dynamic_call(args.task)

# 31 139 8
# source = open(file_dec,encoding="Latin-1")
# data = source.read(1024*1024)
# f= data[0];
# s= data[1];
# t= data[2];

# print("first:", ord(f),"second:", ord(s),"thrid:", ord(t), f,chr(ord(f)))
# source.close()


# with open(file_enc,encoding="Latin-1") as fileobj:
#     for line in fileobj:  
#         for ch in line: 
#             print(ord(ch))

# print(ord('K'))