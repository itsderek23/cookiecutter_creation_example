import pandas as pd
from core.utils import project_dir

def dataset_to_df():
    tweet= pd.read_csv(project_dir() + '/data/raw/train.csv')
    test=pd.read_csv(project_dir() + '/data/raw/test.csv')
    return [tweet,test]
