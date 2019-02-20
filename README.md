[![automation](https://github.com/ctuning/ck-guide-images/blob/master/ck-artifact-automated-and-reusable.svg)](http://cTuning.org/ae)
[![workflow](https://github.com/ctuning/ck-guide-images/blob/master/ck-workflow.svg)](http://cKnowledge.org)

This repository contains the reproducibility report for the SysML'19 paper 
"Priority-based Parameter Propagation for Distributed DNN Training".
Feel free to continue evaluating all experimental results from this paper 
and report your feedback [here](https://github.com/ctuning/reproduce-sysml19-paper-p3/issues).

* **Conference:** [SysML'19](http://sysml.cc)
* **Paper:** Priority-based Parameter Propagation for Distributed DNN Training
* **Authors:** Anand Jayarajan, Jinliang Wei, Garth Gibson, Alexandra Fedorova, Gennady Pekhimenko
* **Artifact DOI:** [Zenodo](https://doi.org/10.5281/zenodo.2549852)
* **Artifact (dev):** [GitHub](https://github.com/anandj91/p3)
* **Evaluation methodology:** [SysML](http://cTuning.org/ae/sysml2019.html), [ACM badging](https://www.acm.org/publications/policies/artifact-review-badging), [ACM REQUEST](http://cKnowledge.org/request)
* **Automated workflow:** [CK](https://github.com/ctuning/ck)
* **Evaluators:** [Grigori Fursin](http://fursin.net/research.html)

# Artifact check-list (meta-information)

* **Program:** python (3.5+), "Priority-based Parameter Propagation (P3)", MXNet, Models {ResNet-50, InceptionV3, VGG-19 and Sockeye}
* **Compilation:** GCC 5.4 or above, CUDA 8 or above, cuDNN6 or above
* **Data set:** ImageNet1K data set; IWSLT15 data set is included
* **Run-time environment:** Ubuntu 16.04+
* **Hardware:** Require more than one machine (four recommended) each equipped with Nvidia GPUs and high bandwidth interconnect (at least 10 Gbps) (tested on AWS and [G5k](https://grid5000.fr))
* **Metrics:** The primary metric of comparison is the average training throughput
* **How much disk space required (approximately)?:** About200 GB per machine should be enough for running experiments. Data set preparation might require about 500 GB
* **How much time is needed to prepare workflow (approximately)?:** About one hour to prepare the dataset and compile the source code
* **How much time is needed to complete experiments (approximately)?:** About 15 minutes per benchmark
* **Code license:** Apache License 2.0

# Installation

We implemented a simple [CK workflow (pipeline)](http://cKnowledge.org) 
with shared [CK packages](http://cKnowledge.org/shared-packages.html)
for this project, models and datasets to automate and facilitate 
validation of results.

## CK framework

Install CK as described [here](https://github.com/ctuning/ck#installation).

## CK workflow (pipeline) for this paper

```
$ ck pull repo:reproduce-sysml19-paper-p3
```

Note that CK will pull all other related repositories.
If you already have installed CK repositories, you may update 
them at any time all as follows:
```
$ ck pull all
```

## Installing packages

Install P3 tool from this paper via CK either from GitHub or Zenodo:
```
$ ck install package:sysml19-p3-github
or
$ ck install package:sysml19-p3-zenodo
```

CK will automatically attempt to detect GCC, CUDA, cuDNN, and install OpenCV and OpenBLAS to a user space.

Install small ImageNet1K train data set just to test workflow (with batch size 1):
```
$ ck install package:imagenet-2012-train-min
```

Install a package which will convert this dataset to P3 format:
```
$ ck install package:dataset-imagenet-2012-train-p3
```

Later you can install a complete ImageNet1K train data set (may take 1 day to download and may require 500GB of space)
```
$ ck install package:imagenet-2012-train
$ ck install package:dataset-imagenet-2012-train-p3
```

Note that if you already have ImageNet1K downloaded and extracted somewhere, you can ask CK to detect it rather then downloading it again:
```
$ ck detect soft:dataset.imagenet.train --search_dirs={path to downloaded and extracted ImageNet1K}
```

# Evaluation

We created CK program workflow (pipeline) with [meta information](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/.cm/meta.json) 
which describes dependencies (code, models and data sets), automates their installation 
during the first execution (P3, data sets, etc) and assembles different command lines.

* [CK run script for resnet, inception-v3 and vgg](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/ck_run.sh)
* [CK run script for sockeye (IWSLT15)](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/ck_run_sockeye.sh) 

Pre-processing CK script prepares list of hosts to run experiments: [preprocess.py](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/preprocess.py).
Post-processing CK script parses output and unifies different metrics: [postprocess.py](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/postprocess.py).

## Cluster preparation

You need to register a list of hosts to run experiments. You can do it as follows:

Just create a "hosts.json" with a list of IPs (make sure that you can ssh there without a password):

```
["chifflet-2", "chifflet-4"]
```

Now you must register this configuration in the CK with some name such as "grid5000" as follows:
```
$ ck add machine:grid5000 --type=cluster --config_file=hosts.json
```

When asked about remote node OS, just select linux-64. You can view all registered configurations of target platforms as follows:
```
$ ck show machine
```

## ImageNet experiments

You can now run ImageNet experiments as follows:

```
$ ck run program:sysml19-p3 --target=grid5000 --cmd_key=resnet
$ ck run program:sysml19-p3 --target=grid5000 --cmd_key=inception-v3
$ ck run program:sysml19-p3 --target=grid5000 --cmd_key=vgg
```

You can change default batch size (32) as follows:
```
$ ck run program:sysml19-p3 --target=grid5000 \
                            --cmd_key=resnet \
                            --env.BATCH_SIZE=32
```

## IWSLT15 experiments

You can also run IWSLT15 experiments as follows:
```
$ ck run program:sysml19-p3 --target=grid5000 --cmd_key=sockeye --env.OUTPUT_FILE=/tmp/sockeye_1.5-iwslt15_en-vi.sh

```

Validated results on [GRID5000](https://www.grid5000.fr): [link](https://github.com/ctuning/reproduce-sysml19-paper-p3/issues/1).


## Suggestions

* Improve [CK post-processing plugin](https://github.com/ctuning/reproduce-sysml19-paper-p3/blob/master/program/sysml19-p3/postprocess.py) for P3 to automatically validate correctness or results

We expect the community to continue validating results from this and other SysML'19 papers.

# Reproducibility badges

TBD

