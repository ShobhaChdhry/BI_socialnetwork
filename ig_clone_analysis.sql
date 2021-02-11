use ig_clone;


---users with their no.of photos

select 
u.username, count(*) nos_photos
from
photos p 
join users u on u.id=p.user_id
group by u.username
order by count(*) desc
;

select * from photos where user_id= 23;

----which tag is used how many times
select 
t.id, t.tag_name tag, count(*) nos_tags
from
photo_tags pt 
join tags t on t.id=pt.tag_id
group by t.id,  t.tag_name
order by count(*) desc
;


select * from photo_tags where tag_id =20;

----------users with no.of photos, no.of photo tags,which tag used how many times, no.of likes,no.of comments, no.of followers,
---kis photo k sabse jyad tag

select 
p.user_id,
pt.photo_id,
(select image_url from photos where id=pt.photo_id),
count(*)
from 
photo_tags pt
join photos p on p.id=pt.photo_id
group by p.user_id,pt.photo_id
order by 2 desc
;



---- no of likes by user on photos and on there photos
select
l.user_id,
sum(case when p.id is not null then 1 else 0 end) nos_likes_on_own_photo,
count(*) total_nos_likes
from
likes l
left join photos p on p.id=l.photo_id and p.user_id=l.user_id
group by l.user_id
order by 3 desc
;





 --which user has most number of comments on his photos

--comments on there own photos
select 
c.user_id,
count(*) "Totalcommentsbyuser",
sum(case when p.id is null then 1 else 0 end) "NosCommentOnOthersPhoto",
sum(case when p.id is not null then 1 else 0 end) "NosCommentOnOwnPhoto"
from comments c
left join photos p on p.id=c.photo_id and p.user_id=c.user_id
group by c.user_id
order by 4 desc
;


-------which user has how many followers

select 
followee_id,
(select username from users where id=followee_id) Name,
count(*) nos_followers
from
follows
group by followee_id
order by count(*) desc
;


--top 5 users with most no. of  followees
select 
follower_id,
(select username from users where id=follower_id) Name,
count(*) nos_followees
from
follows
group by follower_id
order by count(*) desc
limit 5
;

--user with nosofFOllowers and no of follwees
with no_followers as (
select 
followee_id,
(select username from users where id=followee_id) Name,
count(*) nos_followers
from
follows
group by followee_id
),
no_followee as(
select 
follower_id,
(select username from users where id=follower_id) Name,
count(*) nos_followees
from
follows
group by follower_id
)
select
a.name, 
nos_followers,
nos_followees
from no_followers a
join no_followee b on a.followee_id=b.follower_id
order by 1 desc
;
--users and its no.of comments and no.of likes
select
    u.id ,
    u.username,
    nos_likes_on_own_photo, 
    total_nos_likes, 
    Totalcommentsbyuser,
    NosCommentOnOthersPhoto,
    NosCommentOnOwnPhoto
from
users u
left join
(
    select
    l.user_id,
    sum(case when p.id is not null then 1 else 0 end) nos_likes_on_own_photo,
    count(*) total_nos_likes
    from
    likes l
    left join photos p on p.id=l.photo_id and p.user_id=l.user_id
    group by l.user_id
 ) nos_likes on u.id=nos_likes.user_id
left join (
   select 
    c.user_id,
    count(*) "Totalcommentsbyuser",
    sum(case when p.id is null then 1 else 0 end) "NosCommentOnOthersPhoto",
    sum(case when p.id is not null then 1 else 0 end) "NosCommentOnOwnPhoto"
    from comments c
    left join photos p on p.id=c.photo_id and p.user_id=c.user_id
    group by c.user_id
) nos_comments on u.id=nos_comments.user_id
;





