/*------------------------------------------------------------------------------------------
Title: Default Permissions
Description: Our goal in this was to figure out how to grant select on all future tables to 
a group. Essentially the group should inherit select priveleges on any new select. We found that
when the tables are created outside of the root user it we needed to run 

------------------------------------------------------------------------------------------*/



/*---------// group inherits select \\------------
In some cases this allowed us to grant a group select on future tables
we ended up with outages for this solution in some cases. 
This worked when root was the creator*/
alter default privileges in schema my_schema 
grant select on tables 
to group my_group;

/*---------//  Group Inherits Select from table owner \\------------
We found that in the case a user is creating tables other than root that we wanted the table owner
to run this statement*/
alter default privileges for user my_table_owner 
in schema my_schema 
grant select on tables 
to group my_group;
