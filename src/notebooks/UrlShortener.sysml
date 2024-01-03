package UrlShortenerService {

    attribute def HttpRequest;
    attribute def HttpResponse;

    port def HttpInterfacePort {
        in  req : HttpRequest;
        out res : HttpResponse;
    }
    
    port def UserExperiencePort {
        in  input : any;
        out output : any;
    }
    
    
    part user {
        port ui: UserExperiencePort;
    }
    
    part context {
        
        /**
         * The user interface is 
         */
        part UI {
            port ui: ~UserExperiencePort;
            port apiPort: HttpInterfacePort;
        }

        /**
         * The API is a RESTful API written in Node.js
         */
        part API {
            port httpPort: ~HttpInterfacePort;
        }
        
        interface uiToApi connect UI.apiPort to API.httpPort {}
        interface uiToApi connect user to UI {}
        
    }
}