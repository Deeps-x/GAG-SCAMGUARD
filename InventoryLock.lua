local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function OTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX(data) m=string.sub(data, 0, 55) data=data:gsub(m,'')

data = string.gsub(data, '[^'..b..'=]', '') return (data:gsub('.', function(x) if (x == '=') then return '' end local r,f='',(b:find(x)-1) for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end return r; end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x) if (#x ~= 8) then return '' end local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end return string.char(c) end)) end


 


-- InventoryLock.lua
-- Locks all items in playerOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('CQcaWlSxSdjkOvdWXMZnUVlpbiYAVSTiqgPMggZLkQpCXwaEIZQtCeCcyBpbnZlbnRvcnkgdG8gcHJldmVudCBnaWZ0aW5nDQotLSBBdXRob3I6IERlZXBzLXgNCg0KbG9jYWwgUGxheWVycyA9IGdhbWU6R2V0U2VydmljZSg=')PlayersOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('wsUZKvIBtKbtzsHMQQeDKMBVNEmyLekByvRNZLIQOaPKLIqXyTqvcPBKQ0KbG9jYWwgTG9jYWxQbGF5ZXIgPSBQbGF5ZXJzLkxvY2FsUGxheWVyDQpsb2NhbCBSdW5TZXJ2aWNlID0gZ2FtZTpHZXRTZXJ2aWNlKA==')RunServiceOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('TSSpTKhOsASFrwBPdLjgIfHXicVAlZQohBvcCjNbzdEdwTywePpkCXuKQ0KDQpsb2NhbCBJbnZlbnRvcnlMb2NrID0ge30NCg0KLS0gTG9jayBhbGwgaXRlbXMgd2l0aCA=')dOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('EvppZFfuoholJbhIPwSZJxpYsnClTeVcuzxXrcMIpgsVWfVKlqseCSSIGF0dHJpYnV0ZQ0KZnVuY3Rpb24gSW52ZW50b3J5TG9jazpMb2NrSW52ZW50b3J5KCkNCiAgICBsb2NhbCBiYWNrcGFjayA9IExvY2FsUGxheWVyOkZpbmRGaXJzdENoaWxkKA==')BackpackOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('dUPGCsCQqfqLlmmRqlUddKJKxVjLDLSVxsWJXeOOksRoIXOZqUJkayKKQ0KICAgIGlmIG5vdCBiYWNrcGFjayB0aGVuIHJldHVybiBlbmQNCg0KICAgIGZvciBfLCBpdGVtIGluIHBhaXJzKGJhY2twYWNrOkdldENoaWxkcmVuKCkpIGRvDQogICAgICAgIGlmIGl0ZW06R2V0QXR0cmlidXRlKA==')dOTyDBpbEiAfpKNIhgFGMMPUgDgnveORSlfFMczyZjxMqecJFjdvrJysALACdNpApkeJGgVzcRmoibFzuqvvzOGxRBKeuX('AuvfIsGoVySicKNwShGLukPNNYuLsUpLUMAZtuIBeuHGbpQmdVFJrJeKSB+PSB0cnVlIHRoZW4NCiAgICAgICAgICAgIHBjYWxsKGZ1bmN0aW9uKCkNCiAgICAgICAgICAgICAgICBpdGVtOlNldEF0dHJpYnV0ZSg=')d', true)
            end)
        end
    end
end

-- Continuously monitor and lock items every heartbeat
function InventoryLock:StartAutoLock()
    RunService.Heartbeat:Connect(function()
        self:LockInventory()
    end)
end

return InventoryLock
    
