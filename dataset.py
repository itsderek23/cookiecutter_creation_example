import pandas as pd

def dataset_to_df():
    tweet= pd.read_csv('data/raw/train.csv')
    test=pd.read_csv('data/raw/test.csv')
    return [tweet,test]
