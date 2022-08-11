import pandas as pd

def fix_column_names(df):
    for col in df.columns:
        df = df.rename(columns={col: col.lower().replace(' ', '_')})
    return df


def prep_sales():
    
    filename = 'sales.csv'
    date_columns = ['order_date', 'ship_date']

    df = pd.read_csv(filename)
    df = fix_column_names(df)
    for col in date_columns:
        df[col] = pd.to_datetime(df[col])
        df[col] = df[col].dt.strftime('%Y-%m-%d')
    df.to_csv(filename, index=False)


def prep_customers():
    
    filename = 'customers.csv'

    df = pd.read_csv(filename)
    df = fix_column_names(df)
    df.to_csv(filename, index=False)

def main():
    prep_sales()
    prep_customers()

main()