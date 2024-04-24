package live.block360.backend.exceptions;

import org.springframework.http.HttpStatus;

public class AnafRequestException extends RuntimeException{
        private final HttpStatus httpStatus;
        public AnafRequestException(HttpStatus httpStatus, String message) {
            super(message);
            this.httpStatus = httpStatus;
        }

        public HttpStatus getHttpStatus() {
            return httpStatus;
        }

    }

