#!/usr/bin/env python3

import random
import argparse

def gen(n, p, s, f):
    random.seed(s)
    with open(f, "w") as out:
        M = []
        m = 0
        for i in range(1, n):
            for j in range(i + 1, n + 1):
                if random.random() < p:
                    m = m + 1
                    M.append([i, j])
        out.write(f"{n} {m}\n")
        for i in M:
            out.write(f"{i[0]} {i[1]}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Instance generator for the exam scheduling problem.")
    parser.add_argument("-n", "--n-exams",
                        required=True,
                        type=int,
                        help="Number of exams")
    parser.add_argument("-p", "--probability",
                        required=True,
                        type=float,
                        help="Probability of each pair of exams will have a student in common")
    parser.add_argument("-s", "--seed",
                        required=True,
                        type=int,
                        help="The random seed")
    parser.add_argument("-o", "--output",
                        required=True,
                        type=str,
                        help="The name of the output (instance) file generated")
    args = parser.parse_args()
    gen(args.n_exams, args.probability, args.seed, args.output)

if __name__ == "__main__":
    main()
