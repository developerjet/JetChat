# -*- coding: utf-8 -*-
import xlrd
from biplist import *
import collections

def myWritePlist(dict, fileName):
	try:
		writePlist(dict,fileName,False)
	except Exception as e:
		print(e)

def main():
	fileName = "code.xls"
	
	workbook = xlrd.open_workbook(fileName)
	sheet = workbook.sheet_by_index(0)
	
	dic = dict()
	
	for y in range(sheet.ncols):
		if y == 0:
			continue
		for x in range(sheet.nrows):
			if x == 0:
				if dic:
					file = sheet.cell_value(0, y-1)
#                    print(file)
					sortDic = collections.OrderedDict(sorted(dic.items()))
					myWritePlist(sortDic, file)
					dic = dict()
			else:
				key = str(sheet.cell_value(x, 0))
				value = str(sheet.cell_value(x, y))
				dic[key] = value
	
	if dic:
		file = sheet.cell_value(0, sheet.ncols-1)
#        print(file)
		sortDic = collections.OrderedDict(sorted(dic.items()))
		myWritePlist(sortDic, file)

if __name__=="__main__":
	main()
