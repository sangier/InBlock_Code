import random
import sys
import os
import json 
import time
from web3 import Web3, HTTPProvider, IPCProvider
from web3.contract import ConciseContract
import json
from web3.providers.rpc import HTTPProvider


import pandas as pd 
#NB CHANGE PATHS ACCORDINGLY TO YOURS

df = pd.read_csv('C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt', sep=',') 
                  #names=["IP_Address", "ROA", "Max_Length"])
print (df);

#if(df["IP_Address"]==[df["IP_Address"]):
#    print("ok")

#df1=df = df[df.ip_address != 0]
#print(df1)

df.drop_duplicates(subset=["IP_Address","Max_Length"], keep="last",inplace=True)

df.reset_index(drop=True,inplace=True)
print(df)

df.to_csv('C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt',index=False)

#df1=df[df.IP_Address!=-1]
#df3=df1[df1.EstimatedCapacity!=-2] 
#df3=df2[df2.Channel_direction!=1]
#df3.reset_index(drop=True,inplace=True)