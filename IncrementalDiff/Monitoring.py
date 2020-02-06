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




from web3 import Web3
web3= Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))


print("The monitoring program has been started")

def my_callback(event):
    print ('Function is fired from contract')
    print(event)

#N.B. CHANGE THE CONTRACT ADDRESS 
contractAddress = Web3.toChecksumAddress('0x02dab56c36cba8a39ba3e34040674a7d6eefd259')



web3 = Web3(HTTPProvider('http://localhost:8545'))

with open("InBlock.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

changes=0;

fContract = web3.eth.contract(abi=abi,address=contractAddress)

event_filter1 = fContract.events.setRoaEvent.createFilter(fromBlock='latest')
event_filter2 = fContract.events.delegatedPrefixRoaEvent.createFilter(fromBlock='latest')
while True:
    for event in event_filter1.get_new_entries():
        my_callback(event)
        start_time = time.clock()   
        a=fContract.functions.getRoA(event['args']['id1']).call()
        a1=a[0];
        a1=Web3.toHex(a1);
        app=str(a[1]);
        if(app.find(",")==-1):
            a2=Web3.toInt(a[1]);		
        else:
            a2=str(a[1],'utf8')
        a3=str(a[2]);
        print(a1,a2,a3);
        tobesaved=str(a1)+","+str(a3)+","+str(a2)+"\n";
        with open("C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt", "a") as myfile:
            myfile.write(tobesaved);
        end_time = time.clock()
        with open("MonitorTiming.txt", "a") as myfile:
            myfile.write(str(end_time-start_time)+",");
        changes=1;
        print("New Inserted Roa Saved")
        
        
    for event in event_filter2.get_new_entries():
        my_callback(event)
        start_time = time.clock()
        a=fContract.functions.getDelegatedPrefixRoAID(event['args']['id1'],event['args']['id2']).call()
        a1=a[0];
        a1=Web3.toHex(a1);
        app=str(a[1]);
        if(app.find(",")==-1):
            a2=Web3.toInt(a[1]);		
        else:
            a2=str(a[1],'utf8')
        a3=str(a[2]);
        print(a1,a2,a3);
        tobesaved=str(a1)+","+str(a3)+","+str(a2)+"\n";
        with open("C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt", "a") as myfile:
            myfile.write(tobesaved);
        end_time = time.clock()
        with open("MonitorTiming.txt", "a") as myfile:
            myfile.write(str(end_time-start_time)+",");    
        changes=1;
        print("New Inserted Roa Saved")
    print("Going to sleep")
    if(changes==1):
        changes=0;
        df = pd.read_csv('C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt', sep=',') 
        df.drop_duplicates(subset=["IP_Address","Max_Length"], keep="last",inplace=True)
        df.reset_index(drop=True,inplace=True)
        df.to_csv('C:/Users/User/Desktop/Opt_inblock_code/InBlock/contracts/roaTable.txt',index=False)
    time.sleep(60)

