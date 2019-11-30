
# -*- coding: utf-8 -*-
import os
import sys
import xlwt
from biplist import *

def myReadPlist(fileName):
	try: 
		plist = readPlist(fileName)
		return plist

	except Exception as e:
		print(e)
		return dict()

def main():

	files = list()
	for file in os.listdir(os.path.abspath('.')):
		if os.path.isdir(file):
			continue 
		if file.endswith('.plist') and file.startswith('code'):
			files.append(file)


	cnPlist = myReadPlist('code_zh.plist') 
		
	wb = xlwt.Workbook()
	ws = wb.add_sheet('code')

	width = 256*20

	ws.write(0, 0, 'code')
	ws.col(0).width = width
	keys = list(cnPlist.keys())
	keys.sort()
	for x in range(len(keys)):
		key = keys[x]
		ws.write(x+1, 0, key)
	
	
	for y in range(len(files)):
		file = files[y]
#        print(file)
		ws.write(0, y + 1, file)
		ws.col(y + 1).width = width
		plist = myReadPlist(file)
		for x in range(len(keys)):
			key = keys[x]
			value = plist.get(key,'')
			ws.write(x + 1, y + 1, value)


	wb.save("code.xls")


if __name__ == '__main__':
	main()
	
