%w[tempfile uri].map{|l|require l};class Object;def meta_def m,&b
(class<<self;self end).instance_eval{define_method(m,&b)}end end
module Camping;C=self;S=IO.read(__FILE__)rescue nil;P="Cam\ping Problem!"
class H<Hash;def method_missing m,*a
m.to_s=~/=$/?self[$`]=a[0]:a==[]?self[m.to_s]:super end;alias u merge!;end
module Helpers def R c,*g;p,h=/\(.+?\)/,g.grep(Hash)
(g-=h).inject(c.urls.find{|x|x.scan(p).size==g.size}.dup){|s,a|s.sub p,C.
escape((a[a.class.primary_key]rescue a))}+(h.any?? "?"+h[0].map{|x|x.map{|z|C.
escape z}*"="}*"&": "")end;def /(p);p[/^\//]?@root+p:p;end;def URL c='/',*a
c=R(c,*a)if c.respond_to?:urls;c=self/c;c="//"+@env.HTTP_HOST+c if c[/^\//]
URI(c) end end;module Base;attr_accessor:input,:cookies,:env,:headers,:body,
:status,:root;Z="\r\n";def method_missing*a,&b;a.shift if a[0]==:render
m=Mab.new({},self);s=m.capture{send(*a,&b)};s=m.capture{send(:layout){s}}if
/^_/!~a[0].to_s and m.respond_to?:layout;s end;def redirect*a
r 302,'','Location'=>URL(*a)end;def r s,b,h={};@status=s;headers.merge!h
@body=b end;def to_a;[status,body,headers]end;def initialize r,e,m
@status,@method,@env,@headers,@root=200,m.downcase,e,{
'Content-Type'=>"text/html"},e.SCRIPT_NAME.sub(/\/$/,'');@k=C.kp e.HTTP_COOKIE
q=C.qsp e.QUERY_STRING;@in=r;case e.CONTENT_TYPE
when %r|\Amultipart/form-.*boundary=\"?([^\";,]+)|n
b=/(?:\r?\n|\A)#{Regexp::quote"--#$1"}(?:--)?\r$/;until
@in.eof?;fh=H[];for l in@in;case l;when Z;break;when/^Content-D.+?: form-data;/
fh.u H[*$'.scan(/(?:\s(\w+)="([^"]+)")/).flatten];when
/^Content-Type: (.+?)(\r$|\Z)/m;fh.type=$1;end;end;fn=fh.name;o=if fh.
filename;o=fh.tempfile=Tempfile.new(:C);o.binmode;else;fh=""end;s=8192;k=''
l=@in.read(s*2);while l;if(k<<l)=~b;o<<$`.chomp;@in.seek(-$'.size,IO::SEEK_CUR)
break;end;o<<k.slice!(0...s);l=@in.read(s);end;C.qsp(fn,'&;',fh,q)if fn;fh.
tempfile.rewind if fh.is_a?H;end;when "application/x-www-form-urlencoded"
q.u C.qsp(@in.read)end;@cookies,@input=@k.dup,q.dup end;def service*a
@body=send(@method,*a)if respond_to?@method
headers["Set-Cookie"]=cookies.map{|k,v|"#{k}=#{C.escape v}; path=#{self/'/'}"if
v!=@k[k]}-[nil];self end;def to_s;"Status: #@status#{Z+headers.map{|k,v|[*v].
map{|x|[k,v]*": "}}*Z+Z}#@body"end;end;X=module Controllers;@r=[];class<<
self;def r;@r;end;def R*u;r=@r;Class.new{meta_def(:urls){u};meta_def(:inherited
){|x|r<<x}}end;def D p;r.map{|k|k.urls.map{|x|return k,$~[1..-1]if p=~/^#{x
}\/?$/}};[NotFound,[p]]end;def M;def M;end;constants.map{|c|k=const_get(c);k.
send:include,C,Base,Helpers,Models;r[0,0]=k if !r.include?k;k.meta_def(:urls){[
"/#{c.downcase}"]}if !k.respond_to?:urls}end;end;class NotFound<R();def get p
r(404,"<h1>#{P}</h1><h2>#{p} not found</h2>")end end;class ServerError<R()
def get k,m,e;r(500,"<h1>#{P}</h1><h2>#{k}.#{m}</h2><h3>#{e.class} #{e.message
}:<ul>#{e.backtrace.map{ |b| "<li>#{b}</li>" } }")end end;self;end;class<<self
def goes m;eval S.gsub(/Camping/,m.to_s),TOPLEVEL_BINDING;end;def escape s
s.to_s.gsub(/[^ \w.-]+/n){'%'+($&.unpack('H2'*$&.size)*'%').upcase}.tr(' ','+')
end;def un s;s.tr('+',' ').gsub(/%([\da-f]{2})/in){[$1].pack('H*')}end
def qsp q,d='&;',y=nil,z=H[];m=proc{|_,o,n|o.u(n,&m)rescue([*o]<<n)}
(q.to_s.split(/[#{d}]+ */n)-['']).inject((b,z=z,H[])[0]){|h,p|k,v=un(p).
split('=',2);h.u k.split(/[\]\[]+/).reverse.inject(y||v){|x,i|H[i,x]},&m}end
def kp s;c=qsp(s,';,')end;def run r=$stdin,e=ENV;X.M;e=H[e.to_hash]
k,a=X.D e.PATH_INFO=un("/#{e.PATH_INFO}".gsub(/\/+/,'/'));k.new(
r,e,(m=e.REQUEST_METHOD||"GET")).Y.service(*a);rescue=>x;X::ServerError.new(
r,e,'get').service(k,m,x)end;def method_missing m,c,*a;X.M;k=X.const_get(c).
new(StringIO.new,H['HTTP_HOST','','SCRIPT_NAME','','HTTP_COOKIE',''],m.to_s);H.
new(a.pop).each{|e,f|k.send("#{e}=",f)}if Hash===a[-1];k.service(*a);end;end
module Views;include X,Helpers;end;module Models;autoload:Base,'camping/db';def
Y;self;end;end;autoload:Mab,'camping/mab'end
