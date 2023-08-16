# AXI_Memory_Test_Bench

This repository contains a comprehensive SystemVerilog test bench and related files designed to rigorously verify the functionality and data integrity of an AXI Memory. The test bench employs advanced verification techniques, including constrained randomization, to generate an extensive range of test scenarios. These scenarios cover various AXI transactions, addressing modes, data transfers, and response types to validate the AXI memory's behavior thoroughly.

## Introduction

The AXI Memory Verification Test Bench project is focused on ensuring the correctness and reliability of an AXI memory module through exhaustive testing. The test bench generates diverse sequences of AXI transactions, encompassing different transaction types (read, write), burst sizes/types, address ranges, and data patterns.

## Important Notes
- PLEASE NOTE THAT I HAVE NOT WRITTEN THE DESIGN, I HAVE ONLY VERIFIED IT
- design.sv IS NOT WRITTEN BY ME
- EVERYTHING ELSE IS DONE BY ME
- sorry for shouting that out lol, I just wanted it to be seen

## Usage

To run the verification test bench, perform the following steps:

1. Visit this link https://www.edaplayground.com/x/nThb
2. Top right, hit login and create an account
3. Eda Playground might open a new playground for you, so go ahead and click on my link again to open my playground
4. On the left, click on "Open EPWave after run" under Tools & Simulators if you wish to analyze the waveforms
5. hit Run

Throughout the simulation, the test bench orchestrates AXI transactions while interacting with the memory module. Responses from the memory module are rigorously monitored and cross-referenced against expected outcomes, enabling the prompt detection of any anomalies or discrepancies.

