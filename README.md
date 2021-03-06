# OiLiPo

## Background

In college, I majored in Computer Science and Engineering and minored in Creative Writing. This project is an attempt to combine those two pursuits, and demonstrate that technology can enrich art.

This project was inspired by an undergraduate poetry workshop I took with Zoë Brigley Thompson at Ohio State. The exercise was to take a pre-existing poem (yours or someone else's) and replace each noun with the noun that appear 7 positions after it in the dictionary. Alternatively, one could cycle the nouns within the poem 7 spots.

The prompt was to then take a line from the mutated poem and write a poem based on it. The writer could then remove the original line or keep it.

# Implementation

## Accounts

To personalize the experience, I added the ability to log in/out. I did so using the `devise` gem.

The primary page shows poems created when not logged in ("public" poems).

The "New Poem" and "My Poems" pages are only accessible by a logged-in user, and "My Poems" shows only poems from †he currently logged-in user.

## Data models

### Poem
- Title
- Text
- Original
- User id (foreign key)

### User
Attributes provided by `devise`, which include:
- Email
- Encrypted password

# Poem manipulation

![](https://github.com/lizheym/abstract-poetry/blob/master/New%20Poem.gif)

Currently, the application has functionality to perform two actions:
- cycling
- shuffling

On three units:
- adjectives
- nouns
-lines

I used a gem called `engtagger`, which tags parts of speech, allowing me to identify the adjectives and nouns in a poem.

## Implementation

The implementation is fairly straightforward, aside from a few edge cases.
Let's consider the case of nouns, though adjectives are dealt with in the same way.

  1. Find all the nouns in the poem, in the order in which they appear. Including duplicates.
  2. Replace the nouns with an arbitrary placeholder string.
  3. Cycle the list of nouns forward one position (or in the case of shuffling, randomize the order of the array)
  4. Replace the placeholders in the poem with the cycled/shuffled list of nouns
  
## Gem limitations

The `engtagger` gem wasn't perfect, but it was the best pure-Ruby gem I could find (other gems performed better, but were wrappers around Java).

For example, the gem didn't reliably separate punctuation from the identified words. So if a noun was located at the end of the sentence, `engtagger` would include the period in the token with the noun. Then, when cycling the nouns, the period would move around the poem.

I accounted for this in two ways (in order):
  1. Removing trailing punctuation (single character)
  2. Only including in my list of nouns purely alpha strings
  
An additional limitation that I have not corrected for is that sometimes `engtagger` provides false positives. Contractions, for example, are often misidentified as nouns.

## Edge case

Say we have the following input:
```
A girl ate an apple.
```

Without accounting for articles, cycling the nouns would produce
```
A apple ate an girl.
```

That doesn't sound right!

To fix this, I found all articles `["A", "a", "An", "an"]` from the tokenized words and looked ahead to the next word. If it started with a vowel, I corrected to "An"/"an", and otherwise I corrected to "A"/"a".

# Random Poem

![](https://github.com/lizheym/abstract-poetry/blob/master/RandomPoem.png)

An additional feature of this app allows for the generation of a "random" poem.

The Poetry Out Loud website has a large database of poems, and has a link to a random poem from their database:

![](https://github.com/lizheym/abstract-poetry/blob/master/PoetryOutLoudRandom.jpeg)

I used the `open-uri` gem to retrieve the html based on the url.
I then parsed the html with the `nokogiri` gem to retrieve the poem itself from the page.

The algorithm separates the poem into lines and selects a random line.
This process is repeated 10 times, to retrieve 10 random lines

## Edge case

However, I noticed that some of the poems are prose poems, which don't have newlines. The algorithm without modification would insert a full prose poem into the middle of the generated poem. Instead, I only select lines that are fewer than 100 characters long.
This means that the length of the poem will be 10 or fewer lines, rather than exactly 10 lines.

# Public/private

"My Poems" shows all the poems associated with the currenly logged in user. To share poems with others, one can select "make public," which allows that poem to be shown on the index page.

![](https://github.com/lizheym/abstract-poetry/blob/master/Make%20Public.gif)
