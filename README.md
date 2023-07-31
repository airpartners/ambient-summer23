---
editor_options: 
  markdown: 
    wrap: 72
---

# ambient-summer23

This repository focusing on working with 18 Roxbury Modulair and Mod-PM
sensors that are deployed as of Summer 2023. The code in here covers
data acquisition, data pre-processing, plotting, and some other
functionality that are needed for a comprehensive analysis of ambient
data in Roxbury for our goals of identifying the primary sources of
ambient air pollutants in Nubian Square, and quantifying their
proportional contribution to overall exposure.

### Dependencies

As of 08/01/23, this repository is written entirely using R version
4.3.1. The R version output is as follows:

`R version 4.3.1 (2023-06-16) -- "Beagle Scouts"`

`Copyright (C) 2023 The R Foundation for Statistical Computing`

`Platform: x86_64-pc-linux-gnu (64-bit)`

As another side note, as of 08/01/23, this repository is written and run
solely on Ubuntu 22.04.2 LTS. If you are running this code on Ubuntu and
are running into troubles with downloading libraries, make sure to
download the pre-reqs to those libraries using [Posit Package
Manager](https://packagemanager.posit.co/client/#/repos/2/packages/A3)
as a reference

### Using the repository

1.  Clone the repository.

    -   Using SSH
        `git clone git@github.com:airpartners/ambient-summer23.git`
        (Recommended, you will need an SSH key for this, follow [this
        instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent))
    -   Using HTML:
        `git clone https://github.com/airpartners/ambient-summer23.git`

2.  Navigate to the local repository using your terminal. ex:
    `cd ambient-summer23` If this project is correctly compiled, the
    following files should be present:

    -   data-acquisition:
        -   API_call_helpers.R
        -   API_call.Rmd
        -   data_breakdown_helpers.R
        -   data_breakdown.Rmd
        -   data_processing.Rmd
    -   plotting:
        -   aq_ratings.Rmd
        -   pm_stacks.Rmd
        -   polar_plots.Rmd
        -   toggle_map.Rmd
    -   helpers:
        -   exporting_html.R
        -   filtering.Rmd

3.  Below is a workflow chart of this repository.
