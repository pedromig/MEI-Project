import pandas as pd


def seila():
    csv_file = pd.read_csv('data-3.csv')
    mask = csv_file['solver'] == 'code1'
    code_1_data = csv_file[mask]
    code_2_data = csv_file[~mask]
    #print(code_1_data)
    #print(code_2_data)

    #remove solver and max_time columns
    code_1_data = code_1_data.drop(columns = ["solver", "max_time"])
    code_2_data = code_2_data.drop(columns = ["solver", "max_time"])

    # print(code_1_data)
    # print(code_2_data)

    #write to a csv file
    code_1_data.to_csv('code_1_data.csv', float_format='%f', index = False)
    code_2_data.to_csv('code_2_data.csv', float_format='%f', index = False)


if __name__ == '__main__':
    #foda-se
    seila()