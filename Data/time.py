from web3 import Web3
import csv
import datetime
import calendar
import json 
import subprocess
import time 
import os 
import pandas as pd

web3= Web3(Web3.HTTPProvider("https://mainnet.infura.io/v3/4ad76caec3ff46e18f9345629e8670a9"))


download_dir="InBlock_Mainnet_Data_20_32.csv"
csv=open(download_dir,'w')
columnTitleRow="Function,TxHash,BlockNumberInclusion,BlockNumberInclusion+1,BlockNumberInclusion+13,gasUsed,TimestampTxSubmitted,TimestampTxMined,MiningTime,ConfirmationTime\n"
csv.write(columnTitleRow)


df= pd.read_csv('DataInput.csv')

#print(df)

i=0

for i, row in enumerate(df.values):
    Function=df.function[i]
    year=df.year[i] 
    month=df.month[i]
    day=df.day[i] 
    hour=df.hour[i]-1
    minute=df.minute[i]
    second=df.second[i]
    ms=df.ms[i] 
    s = str(year)+"/"+str(month)+"/"+str(day)+"/"+str(hour)+"/"+str(minute)+"/"+str(second)
    date1=datetime.datetime.strptime(s, "%Y/%m/%d/%H/%M/%S")
    Timestamp1=calendar.timegm(date1.utctimetuple())
    TxHash=df.TxHash[i]
    gasUsed = web3.eth.getTransactionReceipt(TxHash).gasUsed
    BlockNumber=web3.eth.getTransaction(TxHash).blockNumber
    Timestamp2=web3.eth.getBlock(BlockNumber+1).timestamp
    ConfirmationTime1=web3.eth.getBlock(BlockNumber+13).timestamp
    Mt=Timestamp2-Timestamp1
    ConfirmationTime=ConfirmationTime1-Timestamp1
    row1=str(Function)+","+str(TxHash)+","+str(BlockNumber)+","+str(BlockNumber+1)+","+str(BlockNumber+13)+","+str(gasUsed)+","+str(Timestamp1)+","+str(Timestamp2)+","+str(Mt)+","+str(ConfirmationTime)
    csv.write(row1+"\n")
    print(row1)
    print(i)
    

	

