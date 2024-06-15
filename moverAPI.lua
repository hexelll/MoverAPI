--constructor for the moverAPI object
function moverAPI()
    local self = {}
    self.getters = {}
    self.targets = {}
    self.controls = {}
    self.coeffs = {}
    --sets the target angle for an index i
    self.setTarget = function(i,target)
        self.targets[i] = target
        return self
    end
    --sets the rotationSpeedController for an index i
    self.setController = function(i,controller)
        self.controls[i] = controller
        return self
    end
    --sets the constant to multiply the value going into the rotationSpeedController by for an index i used to take gear ratios into account
    self.setK = function(i,K)
        self.coeffs[i] = K
        return self
    end
    --sets the function to call to get the current angle for an index i
    self.setGetter = function(i,getter)
        self.getters[i] = getter
        return self
    end
    --sets the time for your thing to get to the desired angle for an index i
    self.setHorizon = function(horizon)
        self.horizon = horizon
        return self
    end
    --moves all your things
    self.loop = function()
        local toRun = {}
        for i,get in pairs(self.getters) do
            table.insert(toRun,function()
            while true do
                local target = self.targets[i]
                local controller = self.controls[i]
                local diff = self.targets[i]-get()
                local h = self.horizon or 1
                local k = self.coeffs[i] or 1
                local rpm
                while h > 0.1 do
                    diff = self.targets[i]-get()
                    rpm = diff/(h/60)/360
                    controller.setTargetSpeed(k*rpm)
                    sleep(h)
                    controller.setTargetSpeed(0)
                    h = h / 2
                end
                sleep()
            end
            end)
        end
        parallel.waitForAll(table.unpack(toRun))
    end
    return self
end

return moverAPI
