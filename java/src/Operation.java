import org.apache.commons.lang.StringUtils;

import com.datacash.mmp.common.beans.request.DeleteMerchantRequest;
import com.datacash.mmp.common.beans.request.Request;
import com.datacash.mmp.common.beans.request.ViewRequest;
import com.datacash.mmp.common.beans.response.MerchantResponse;
import com.datacash.mmp.common.beans.response.Response;
import com.datacash.mmp.common.model.MerchantSetup;

@SuppressWarnings( { "unchecked", "rawtypes" } )
public enum Operation {
	//	ADD {
	//
	//		@Override
	//		public Class<? extends Request> getRequest( Class<? extends MerchantSetup> source ) {
	//			return Mapper.forClass( source ).forOperation( Operation.ADD ).getMmpOperation().getWsRequestClass();
	//		}
	//	},

	DELETE {
		@Override
		public Class<? extends Request> getRequest( Class<? extends MerchantSetup> source ) {
			return DeleteMerchantRequest.class;
		}
	},

	EDIT {

		@Override
		public Class<? extends Request> getRequest( Class<? extends MerchantSetup> source ) {
			return (Class<? extends Request>) classFor( "com.datacash.mmp.common.beans.request.Edit" + source.getSimpleName() + "Request" );
		}

	},

	VIEW {

		@Override
		public Class<? extends Request> getRequest( Class<? extends MerchantSetup> source ) {
			return ViewRequest.class;
		}

		@Override
		public Class<? extends Response> getResponse( Class<? extends MerchantSetup> source ) {
			return (Class<? extends Response>) classFor( "com.datacash.mmp.common.beans.response.View" + source.getSimpleName() + "Response" );
		}

	};


	public String getURLSuffix() {
		return "/" + StringUtils.lowerCase( name() );
	}

	public String getInternalOperationPrefix() {
		return StringUtils.lowerCase( name() ) + "_";
	}


	/**
	 * @param source
	 */
	public Class<? extends Request> getRequest( Class<? extends MerchantSetup> source ) {
		return Request.class;
	}

	/**
	 * @param source
	 */
	public Class<? extends Response> getResponse( Class<? extends MerchantSetup> source ) {
		return MerchantResponse.class;
	}


	private static Class<?> classFor( String clazz ) {
		try {
			return Class.forName( clazz );
		}
		catch ( ClassNotFoundException e ) {
			throw new RuntimeException( e );
		}
	}
}