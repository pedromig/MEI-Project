#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats.stats import pearsonr, spearmanr
import numpy as np
from math import log10


def esp_pearson_heatmap(df):
    df = df.drop(["instance_seed", "solver_seed", "slots", "max_time"], axis=1)
    df = df.sort_values(["exams", "probability"])

    for solver in df["solver"].unique():
        # Probability Correlation Plots
        fixed_prob = [[], []]
        for p in df["probability"].unique():
            table = df[(df["probability"] == p) & (df["solver"] == solver)]
            c, r = pearsonr(table["time"], table["exams"])
            fixed_prob[0].append(c)
            c, r = pearsonr(table["time"].apply(log10), table["exams"])
            fixed_prob[1].append(c)

        plt.matshow(fixed_prob, cmap='coolwarm')
        plt.colorbar()
        plt.xticks(range(len(df["probability"].unique())), [
                   f"P={x}" for x in df["probability"].unique()])
        plt.yticks(range(2), ["Linear Scale", "Logarithmic Scale"])
        plt.title(f"T & N correlation - {solver.capitalize()}")
        for (x, y), value in np.ndenumerate(fixed_prob):
            plt.text(y, x, round(value, 2), ha='center')

        # Exam Correlation Plots
        fixed_exams = [[], []]
        for e in df["exams"].unique():
            table = df[(df["exams"] == e) & (df["solver"] == solver)]
            c, r = pearsonr(table["time"], table["probability"])
            fixed_exams[0].append(c)
            c, r = pearsonr(table["time"].apply(log10), table["probability"])
            fixed_exams[1].append(c)

        plt.matshow(fixed_exams, cmap='coolwarm')
        plt.colorbar()
        plt.xticks(range(len(df["exams"].unique())), [
                   f"N={x}" for x in df["exams"].unique()])
        plt.yticks(range(2), ["Linear Scale", "Logarithmic Scale"])
        plt.title(f"T & P correlation: {solver.capitalize()}")
        for (x, y), value in np.ndenumerate(fixed_exams):
            plt.text(y, x, round(value, 2), ha='center')
        plt.show()


def esp_spearman_heatmap(df):
    df = df.drop(["instance_seed", "solver_seed", "slots", "max_time"], axis=1)
    df = df.sort_values(["exams", "probability"])

    for solver in df["solver"].unique():

        # Probability Correlation Plots
        fixed_prob = [[]]
        for p in df["probability"].unique():
            table = df[(df["probability"] == p) & (df["solver"] == solver)]
            c, r = spearmanr(table["time"], table["exams"])
            fixed_prob[0].append(c)

        plt.matshow(fixed_prob, cmap='coolwarm')
        plt.colorbar()
        plt.xticks(range(len(df["probability"].unique())), [
                   f"P={x}" for x in df["probability"].unique()])
        plt.yticks(range(1), [""])
        plt.title(f"T & N correlation - {solver.capitalize()}")
        for (x, y), value in np.ndenumerate(fixed_prob):
            plt.text(y, x, round(value, 2), ha='center')

        # Exam Correlation Plots
        fixed_exams = [[]]
        for e in df["exams"].unique():
            table = df[(df["exams"] == e) & (df["solver"] == solver)]
            c, r = pearsonr(table["time"], table["probability"])
            fixed_exams[0].append(c)

        plt.matshow(fixed_exams, cmap='coolwarm')
        plt.colorbar()
        plt.xticks(range(len(df["exams"].unique())), [
                   f"N={x}" for x in df["exams"].unique()])
        plt.yticks(range(1), [""])
        plt.title(f"T & P correlation: {solver.capitalize()}")
        for (x, y), value in np.ndenumerate(fixed_exams):
            plt.text(y, x, round(value, 2), ha='center')
        plt.show()


def esp_lmm(df):
    df = df.sort_values(["exams", "probability"])
    for scale in ["Linear", "Logarithmic"]:
        for solver in df["solver"].unique():
            fig, ax = plt.subplots(
                1, len(df["probability"].unique()), figsize=(20, 5))
            fig.suptitle(
                f"{solver.capitalize()} Linear Regression - {scale} Scale", fontsize=14)
            for i, p in enumerate(df["probability"].unique()):
                table = df[(df["probability"] == p) &
                           (df["solver"] == solver)]
                plt.subplot(1, len(df["probability"].unique()), i+1)
                plt.title(f"Probability={p}")
                if scale == "Logarithmic":
                    sns.regplot(x=table["exams"],
                                y=table["time"].apply(log10))
                else:
                    sns.regplot(x=table["exams"], y=table["time"])
            fig, ax = plt.subplots(
                3, (len(df["exams"].unique()) - 1) // 3, figsize=(30, 15))
            fig.suptitle(
                f"{solver.capitalize()} Linear Regression - {scale} Scale", fontsize=50)
            for i, e in enumerate(list(df["exams"].unique())[:-1]):
                table = df[(df["exams"] == e) & (df["solver"] == solver)]
                plt.subplot(3, (len(df["exams"].unique()) - 1) // 3, i+1)
                plt.title(f"Exams={e}")
                if scale == "Logarithmic":
                    sns.regplot(x=table["probability"],
                                y=table["time"].apply(log10))
                else:
                    sns.regplot(x=table["probability"], y=table["time"])
    plt.show()


def esp_boxplotm(df):
    df = df.drop(["slots", "max_time"], axis=1)
    df = df.sort_values(["exams", "probability"])
    df["Instance"] = list(zip(df["exams"], df["probability"]))

    for solver in ["code1", "code2"]:
        fig, ax = plt.subplots(
            len(df["exams"].unique()), len(df["probability"].unique()))
        fig.suptitle(f"{solver.capitalize()} Box Plot", fontsize=50)
        for i, e in enumerate(df["exams"].unique()):
            for j, p in enumerate(df["probability"].unique()):
                table = df[(df["solver"] == solver) & (
                    df["exams"] == e) & (df["probability"] == p)]
                sns.boxplot(x="Instance", y="time", data=table,
                            hue="instance_seed", ax=ax[i, j])
                plt.title(f"N: {e} | P: {p} | Solver: {solver}")
        plt.show()


if __name__ == "__main__":
    df = pd.read_csv("../docs/others/data/data_21_12_2021.csv")
    # esp_pearson_heatmap(df)
    # esp_spearman_heatmapdf)
