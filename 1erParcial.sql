create table MEMBER
(
member_id number(10)
             constraint mem_id_pk Primary key
,last_name varchar2(25)
            constraint meme_id_nn not null
,first_name varchar2(25)
,address varchar2(100)
,city varchar2(30)
,phone varchar2(15)
,join_date date default sysdate
            constraint jn_dte_nn not null
);
DESC MEMBER;



create table TITLE
(
title_id number(10)
             constraint tle_id_pk primary key
,title varchar2(60)
              constraint tle_nn not null
,description varchar(400)
             constraint desc_nn not null
,rating varchar2(4)
             constraint ratng_chk check(rating in('G','PG','R','NC17','NR'))
,category varchar2(20)
              constraint catgry_chk check(category in('DRAMA','COMEDY','ACTION','CHILD','SCIFI','DOCUMENTARY'))
,release_date date
);
DESC TITLE;

create table TITLE_COPY
(
copy_id number(10),
title_id number(10),
status varchar2(15)
             constraint stus_chk check(status in('AVAILABLE','DESTROYED','RENTED','RESERVED'))
,constraint pk_tle primary key(copy_id,title_id)
,constraint tle_id_fk foreign key(title_id) references title(title_id)
);
DESC TITLE_COPY;


create table RENTAL
(
book_date date default sysdate,
member_id number(10),
copy_id number(10),
act_ret_date date,
exp_ret_date date default sysdate + 2,
title_id number(10),
constraint pk_rnt primary key(book_date,member_id,copy_id,title_id),
constraint mbr_id_fk foreign key(member_id) references member(member_id),
constraint cpy_id_fk foreign key(copy_id,title_id) references title_copy(copy_id,title_id)
);
DESC RENTAL;

create table reservation
(
res_date date,
member_id number(10),
title_id number(10),
constraint pk_rsr primary key(res_date,member_id,title_id),
constraint mr_id_fk foreign key(member_id) references member(member_id),
constraint t_id_fk foreign key(title_id) references title(title_id)
);
DESC RESERVATION;


create sequence MEMBER_ID_SEQ
              START WITH 101
              NOCACHE;

create sequence TITLE_ID_SEQ
             START WITH 92
             NOCACHE;
             
             
            

alter session set nls_date_format='dd-mon-yyyy';
insert into member
values (member_id_seq.nextval,'Velasquez','Carmen','283 King Street','Seattle','206-899-6666','8-3-90');
insert into member
values(member_id_seq.nextval,'Ngao','LaDoris','5 Modrany','Bratislava','586-355-8862','8-3-90');
insert into member
values(member_id_seq.nextval,'Nagayama','Midori','68 Via Centrale','Sao Paolo','254-852-5764','17-6-91');
insert into member
values(member_id_seq.nextval ,'Quick-to-See','Mark','6921 King Way','Lagos','563-559-7777','7-4-90');
insert into member
values(member_id_seq.nextval, 'Ropeburn','Audry','86 Chu Street','Hong Kong','401-559-8788','18-1-91');
insert into member
 values(member_id_seq.nextval,'Urguhart','Molly','3035 Laurier','Quebec','418-542-9988','18-1-91');

select*from  member;


alter session set nls_date_format='dd-mm-yyyy';
insert into title
values(title_id_seq.nextval,'Willie and Chrismas Too','All of Willie’s friends make a Christmas list for Santa, but Willie hast yet to add his own wish list
','G','CHILD','5-10-95');
insert into title
values(title_id_seq.nextval,'Alien Again','Yet another installation of science fiction history.  Can the heroine save the planet from the alien life form?
','R','SCIFI','19-5-95');
insert into title
values (title_id_seq.nextval,'The Glob','A meteor crashes near a small American town and unleashes carnivorous goo in this classic
','NR','SCIFI','12-8-95');
insert into title
values (title_id_seq.nextval,'My Day Off','With a little luck and a lot of ingenuity, a teenager skips school for a day in New York
','PG','COMEDY','12-6-95');
insert into title
values(title_id_seq.nextval, 'Miracles on Ice','A six-year-old has doubts about Santa Claus, but she discovers that miracles really do exist
','PG','DRAMA','12-6-95');
insert into title
values(title_id_seq.nextval,'Soda Gang','After discovering a cache of drugs, a young couple find themselves pitted against a vicious gang
','NR','ACTION','1-6-95');

select* from title;

insert into title_copy
values (1,92,'AVAILABLE');
insert into title_copy
values(1,93,'AVAILABLE');
insert into title_copy
values(2,93,'RENTED');
insert into title_copy
values(1,94,'AVAILABLE');
insert into title_copy
values(1,95,'AVAILABLE');
insert into title_copy
values(2,95,'AVAILABLE');
insert into title_copy
values(3,95,'RENTED');
insert into title_copy
values(1,96,'AVAILABLE');
insert into title_copy
values(1,97,'AVAILABLE');

select*from title_copy;

insert into rental
values (sysdate-3,103,1,sysdate,sysdate-1,92);

insert into rental
values (sysdate-1,103,2,sysdate,sysdate+1,93);
insert into rental
values(sysdate-2,104,3,sysdate-1,sysdate,95);
insert into rental
values(sysdate-4,102,1,sysdate-1,sysdate-2,97);

select*from rental;


insert into reservation
values(sysdate-1,106,94);
insert into reservation
values(sysdate-2,107,96);
insert into reservation
values(sysdate-4,105,97);
select* from reservation;

create or replace view TITLE_AVAIL
as select  m.member_id, m.last_name,m.first_name,m.city,r.book_date,
r.exp_ret_date, r.act_ret_date, t.title_id,t.title,t.rating,t.category,
t.release_date,tc.copy_id,tc.status
from rental r
inner join member m on (r.member_id = m.member_id)
inner join title_copy tc on(tc.title_id = r.title_id)
inner join title t on(r.title_id = t.title_id);
select*from title_avail order by member_id;
