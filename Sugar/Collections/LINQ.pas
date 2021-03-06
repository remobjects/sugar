﻿namespace Sugar.Linq;

interface

uses
  Sugar.Collections,
  {$IF ECHOES}
  System.Collections.Generic;
  {$ELSEIF COOPER}
  com.remobjects.elements.linq;
  {$ELSEIF TOFFEE}
  Foundation,
  RemObjects.Elements.Linq;
  {$ENDIF}

extension method ISequence<T>.Contains<T>(arg: T): Boolean; {$IF ECHOES}where T is IEquatable<T>; {$ELSEIF TOFFEE}where T is class; {$ENDIF}

{$IF ECHOES}
[assembly: NamespaceAlias('Sugar.Linq', ['System.Linq'])]
{$ELSEIF COOPER}
[assembly: NamespaceAlias('Sugar.Linq', ['com.remobjects.elements.linq'])]
{$ELSEIF TOFFEE}
[assembly: NamespaceAlias('Sugar.Linq', ['RemObjects.Elements.Linq'])]
{$ENDIF}

{$IF TOFFEE}
extension method Foundation.INSFastEnumeration.ToList: not nullable List<id>; public;
extension method Foundation.INSFastEnumeration.ToDictionary(aKeyBlock: IDBlock; aValueBlock: IDBlock): not nullable Dictionary<id,id>; public;
extension method RemObjects.Elements.System.INSFastEnumeration<T>.ToList: not nullable List<T>; inline; public;
//extension method RemObjects.Elements.System.INSFastEnumeration<T>.ToDictionary<K,V>(aKeyBlock: block(aItem: id): K; aValueBlock: block(aItem: id): V): not nullable Dictionary<K,V>; public;
{$ENDIF}

implementation

extension method ISequence<T>.Contains<T>(arg: T): Boolean;
begin
  if self is List<T> then
    exit (self as List<T>).Contains(arg);
  for each i in self do begin
    if (i = nil) then begin
      if (arg = nil) then exit true;
    end
    else begin
      {$IF COOPER OR ECHOES OR ISLAND}
      if i.Equals(arg) then exit true;
      {$ELSEIF TOFFEE}
      if i.isEqual(arg) then exit true;
      {$ENDIF}
    end;
  end;
end;

{$IF TOFFEE}
extension method Foundation.INSFastEnumeration.ToList(): not nullable List<id>;
begin
  result := self.array().mutableCopy() as not nullable;
end;

extension method Foundation.INSFastEnumeration.ToDictionary(aKeyBlock: IDBlock; aValueBlock: IDBlock): not nullable Dictionary<id,id>;
begin
  result := dictionary(aKeyBlock, aValueBlock) as NSMutableDictionary;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.ToList: not nullable List<T>;
begin
  exit Foundation.INSFastEnumeration(self).array().mutableCopy() as not nullable;
end;

{extension method RemObjects.Elements.System.INSFastEnumeration<T>.ToDictionary<K,V>(aKeyBlock: block(aItem: id): K; aValueBlock: block(aItem: id): V): not nullable Dictionary<K,V>;
begin
  exit Foundation.INSFastEnumeration(self).dictionary(IDBlock(aKeyBlock), IDBlock(aValueBlock));
end;}
{$ENDIF}

end.
    