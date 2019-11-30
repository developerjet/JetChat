#!/bin/sh

#  Localizable.sh
#  IDCMExchange
#
#  Created by fisker.zhang on 2018/4/8.
#  Copyright © 2018年 IDC. All rights reserved.

#=============Localizable
locPath="${SRCROOT}/FY-IMChat/Classes/Resource/Languages/"

exportToExcel="exportToExcel.py"
importLocalizable="importLocalizable.py"

# 0导出 1导入  2不干嘛
locFun=2

#跳转路径
cd $locPath
if [ $locFun -eq 0 ]; then
echo "Localizable--------------------------------导出"
python3 $exportToExcel
elif [ $locFun -eq 1 ]; then
echo "Localizable--------------------------------导入"
python3 $importLocalizable
else
echo "Localizable--------------------------------None"
fi

#=============Code
codePath="${SRCROOT}/FY-IMChat/Classes/Resource/code/"

exportCode="exportCode.py"
importCode="importCode.py"

#0导出 1导入  2不干嘛
codeFun=2

#跳转路径
cd $codePath
if [ $codeFun -eq 0 ]; then
echo "Code--------------------------------导出"
python3 $exportCode
elif [ $codeFun -eq 1 ]; then
echo "Code--------------------------------导入"
python3 $importCode
else
echo "Code--------------------------------None"
fi
