Cyrus Innovation Code Test - Ruby
Submission by Jigar Vora
----------------

Using Ruby 1.9.2-p290

How to run:
ruby tc_testRecordsOrganizer.rb

----------------
Here is my approach when creating the program:

1. Structure to store the records: 
  - Create an array of hashes to store the master list.
  - A hash will be useful to access properties of each record easily. It could also be useful for additional functionality in the future.
  - An array is used because Ruby provides robust sorting methods for Arrays.

2. Try to make it scalable/flexible by making the methods parameterized. This allows new features to be easily added.

3. Instead of ignoring fields like "MiddleInitial" because they aren't needed for output, I'm storing it in case its needed in the future.
   On line 15 of fileParser.rb, you see that I've changed the default hash value to "". This allows the records to be sorted by Middle Initial even if all of the records don't have that information (instead of getting an invalid null comparison error).




