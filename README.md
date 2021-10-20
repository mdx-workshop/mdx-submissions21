# MDX Workshop Submissions
⏰ _Abstract Deadline:_ ~~October 22th 2021~~ __Deadline Extension: October 28th 2021 (Anywhere on Earth)__

The MDX21 workshop is a satellite event at [ISMIR 2021](https://ismir2021.ismir.net/). We will feature invited talks as well as presentations and posters from submitted extended abstracts. The contents of the extended abstracts can be descriptions of your submission to the MDX21 challenge as well as other topics around audio source separation that you would like to share with the community.

This is the submission repository for the [Music Demixing Workshop 2021](https://mdx-workshop.github.io). The submission system is based on Github pull requests and is fully transparent and open for both, authors and reviewers.

Extended abstracts are written in markdown and following the [MDX workshop template](https://github.com/mdx-workshop/mdx-submissions21) (originally forked from the [JOSS](https://joss.theoj.org/) paper system).

There is no page limit on the papers, but please make sure that the abstract itself is within 250 words.
In case you have any question, please open an [issue in this repository](https://github.com/mdx-workshop/mdx-submissions21/issues).

### Submission types

We accept three kinds of submissions:

- **Posters.** We encourage everyone who participated in the Music Demixing Challenge to submit a poster. After a minimal prescreening, you would have the opportunity to present your work in the online virtual space for the conference. Pick the `POSTERS` category, and submit a title + short abstract.

- **Long presentations** (20min+questions), during which you can present a recent research or some topic you think could be of interest to the community. Pick the `LONG TALK` category, and submit a title + extended abstract for your talk.

- **Discussions** (30min), during which you propose to initiate and moderate a group discussion about a particular topic after a 5min introduction. The objective is to stimulate new ideas and collaborations on music separations. Pick the `DISCUSSIONS` category, and submit a title + extended abstract that describes discussion topics.

### How to write an article

All submissions are created via markdown files and uses the same template and syntax as in the [Journal of Open Source Software](https://joss.readthedocs.io/en/latest/submitting.html). An example paper can be seen in [paper.md](/paper.md).

### How to submit an article ?

1. Create a [github](https://github.com) account

2. [Fork](https://help.github.com/articles/fork-a-repo/) the [MDX workshop submission](https://github.com/mdx-workshop/mdx-submissions21) repository

3. Clone this new repository into your desktop environment

   ```
   $ git clone https://github.com/YOUR-USERNAME/mdx-submissions21
   ```

4. Create a branch (the branch name should be author names separated with dashes)

   ```
   $ git checkout -b AUTHOR1-AUTHOR2
   ```


5. Add your article and commit your changes:

   ```
   $ git commit -a -m "Some comment"
   ```


6. [Push](https://help.github.com/articles/pushing-to-a-remote/) to github

   ```
   $ git push origin AUTHOR1-AUTHOR2
   ```

7. Issue a [pull request](https://help.github.com/articles/using-pull-requests/) (PR) with title containing author(s) name and follow the template that will appear once you opened the pull request.

9. Answer questions and requests by the reviewers made in the PR conversation page.

10. The pull request will be closed when the paper is accepted and published.

### How to preview an article

All markdown papers are automatically compiled to PDF using a github action service. This can be used to preview the PDF before submission. Look for the `paper` artifacts of the `Paper Draft`.

<img width="1369" alt="screenshot" src="https://user-images.githubusercontent.com/72940/128880968-51d10e51-c1d7-4892-bb4f-8071bb164594.png">
